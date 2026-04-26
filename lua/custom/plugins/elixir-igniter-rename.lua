local function project_root()
  local root = vim.fs.root(0, { "mix.exs", ".git" })
  if root and root ~= "" then
    return root
  end

  local git = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if git and git ~= "" and vim.v.shell_error == 0 then
    return git
  end

  return (vim.uv or vim.loop).cwd()
end

local function find_current_module(bufnr, line_nr)
  for l = line_nr, 1, -1 do
    local line = vim.api.nvim_buf_get_lines(bufnr, l - 1, l, false)[1]
    if line then
      local mod = line:match("^%s*defmodule%s+([%w_%.]+)")
      if mod then
        return mod
      end
    end
  end
  return nil
end

local function parse_def_head(line)
  local name, params = line:match("^%s*defp?%s+([%w_!%?]+)%s*%((.*)%)")
  if not name then
    return nil, nil
  end
  local function arity_of(param_str)
    local lvl, commas = 0, 0
    for c in param_str:gmatch(".") do
      if c == "(" or c == "[" or c == "{" then
        lvl = lvl + 1
      elseif c == ")" or c == "]" or c == "}" then
        lvl = lvl - 1
      elseif c == "," and lvl == 0 then
        commas = commas + 1
      end
    end
    if param_str:match("^%s*$") then
      return 0
    end
    return commas + 1
  end
  return name, arity_of(params)
end

local function detect_fun_at_cursor()
  local bufnr = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1] or ""
  local fname, arity = parse_def_head(line)
  local mod = find_current_module(bufnr, row)
  if fname and mod then
    return { module = mod, name = fname, arity = arity }
  end
  local ident = vim.fn.expand("<cword>")
  local esc = vim.pesc or function(s)
    return (s:gsub("(%W)", "%%%1"))
  end
  local modprefix = ident and line:match("([%w_%.]+)%s*%.%s*" .. esc(ident) .. "%s*%(") or nil
  return { module = modprefix or mod, name = ident, arity = nil }
end

local function ask(prompt, default, cb)
  vim.ui.input(
    { prompt = default and (prompt .. " [" .. default .. "]: ") or (prompt .. ": "), default = default },
    function(ans)
      cb((ans == nil or ans == "") and default or ans)
    end
  )
end

local function choose(title, items, default_idx, cb)
  vim.ui.select(items, {
    prompt = title,
    format_item = function(x)
      return x
    end,
  }, function(choice, idx)
    cb(choice or items[default_idx], idx or default_idx)
  end)
end

local function get_result_buf()
  local name = "Igniter Rename Result"
  local bufnr = vim.fn.bufnr(name)
  if bufnr == -1 then
    bufnr = vim.api.nvim_create_buf(false, true)
    -- set name once; subsequent calls reuse the same buffer
    vim.api.nvim_buf_set_name(bufnr, name)
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = bufnr })
    vim.api.nvim_set_option_value("swapfile", false, { buf = bufnr })
  end
  return bufnr
end

local function show_in_vsplit(bufnr)
  local win = vim.fn.bufwinnr(bufnr)
  if win == -1 then
    vim.cmd("vsplit")
    vim.api.nvim_win_set_buf(0, bufnr)
  else
    vim.cmd(tostring(win) .. "wincmd w")
  end
end

local function render_result(bufnr, cwd, cmd, stdout, stderr)
  vim.api.nvim_set_option_value("modifiable", true, { buf = bufnr })
  local lines = {
    "cwd: " .. cwd,
    "cmd: " .. table.concat(cmd, " "),
    "",
    "== stdout ==",
  }
  if stdout ~= "" then
    for s in (stdout .. "\n"):gmatch("([^\n]*)\n") do
      table.insert(lines, s)
    end
  end
  if stderr ~= "" then
    table.insert(lines, "")
    table.insert(lines, "== stderr ==")
    for s in (stderr .. "\n"):gmatch("([^\n]*)\n") do
      table.insert(lines, s)
    end
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
  vim.api.nvim_set_option_value("filetype", "log", { buf = bufnr })
end

local function run_mix(cmd, cwd)
  local res = vim.system(cmd, { cwd = cwd, text = true }):wait()
  local bufnr = get_result_buf()
  render_result(bufnr, cwd, cmd, res.stdout or "", res.stderr or "")
  show_in_vsplit(bufnr)
  if res.code ~= 0 then
    vim.notify("igniter rename failed (exit " .. tostring(res.code) .. ")", vim.log.levels.ERROR)
  else
    vim.notify("igniter rename finished", vim.log.levels.INFO)
  end
end

local function build_old_spec(ctx, with_arity)
  if not ctx.module or not ctx.name then
    return nil
  end
  if with_arity and ctx.arity ~= nil then
    return string.format("%s.%s/%d", ctx.module, ctx.name, ctx.arity)
  else
    return string.format("%s.%s", ctx.module, ctx.name)
  end
end

local function prompt_and_rename()
  local root = project_root()
  local ctx = detect_fun_at_cursor()
  if not ctx.module or not ctx.name then
    vim.notify("Could not detect module/function at cursor", vim.log.levels.WARN)
    return
  end
  local old_spec = build_old_spec(ctx, true) or (ctx.module .. "." .. ctx.name)
  local new_default = ctx.module .. "." .. ctx.name .. "_new"

  choose("Deprecation mode", { "none", "soft", "hard" }, 1, function(dep)
    ask("New (module.fun)", new_default, function(new_spec)
      ask("Extra args (optional)", "", function(extra)
        local cmd = { "mix", "igniter.refactor.rename_function", old_spec, new_spec }
        if dep and dep ~= "none" then
          table.insert(cmd, "--deprecate")
          table.insert(cmd, dep)
        end
        if extra and extra ~= "" then
          for tok in extra:gmatch("%S+") do
            table.insert(cmd, tok)
          end
        end
        table.insert(cmd, "--yes")
        run_mix(cmd, root)
      end)
    end)
  end)
end

return {
  dir = vim.fn.stdpath("config"),
  name = "elixir-igniter-rename",
  ft = "elixir",
  keys = {
    { "<leader>ri", prompt_and_rename, desc = "Igniter: Rename Function" },
    {
      "<leader>rI",
      function()
        local root = project_root()
        vim.ui.input({ prompt = "mix igniter.refactor.rename_function (full args): " }, function(line)
          if not line or line == "" then
            return
          end

          local args = {}
          for tok in line:gmatch("%S+") do
            table.insert(args, tok)
          end

          local cmd = { "mix", "igniter.refactor.rename_function" }
          vim.list_extend(cmd, args)
          local joined = " " .. table.concat(cmd, " ") .. " "
          if not joined:match("%s%-%-yes%s") and not joined:match("%s%-%-dry%-run%s") then
            table.insert(cmd, "--yes")
          end
          run_mix(cmd, root)
        end)
      end,
      desc = "Igniter: Raw Command",
    },
  },
  cmd = { "IgniterRename" },
  config = function()
    vim.api.nvim_create_user_command("IgniterRename", function(opts)
      local root = project_root()
      local argv = {}
      for tok in (opts.args or ""):gmatch("%S+") do
        table.insert(argv, tok)
      end
      if #argv < 2 then
        vim.notify("Usage: :IgniterRename OldSpec NewSpec [--deprecate soft|hard ...]", vim.log.levels.WARN)
        return
      end

      local cmd = { "mix", "igniter.refactor.rename_function" }
      vim.list_extend(cmd, argv)
      local joined = " " .. table.concat(cmd, " ") .. " "
      if not joined:match("%s%-%-yes%s") and not joined:match("%s%-%-dry%-run%s") then
        table.insert(cmd, "--yes")
      end
      run_mix(cmd, root)
    end, { nargs = "+" })
  end,
}

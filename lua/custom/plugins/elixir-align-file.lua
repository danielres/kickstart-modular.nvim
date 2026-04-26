local uv = vim.uv or vim.loop
local tbl_unpack = table.unpack or unpack

local function join_paths(...)
  if vim.fs.joinpath then
    return vim.fs.joinpath(...)
  end

  return table.concat({ ... }, '/')
end

local function split_module(module_name)
  local parts = {}
  for part in module_name:gmatch '[^.]+' do
    table.insert(parts, part)
  end
  return parts
end

local function snake_case(segment)
  local snake = segment
  snake = snake:gsub('(%u+)(%u%l)', '%1_%2')
  snake = snake:gsub('([%l%d])(%u)', '%1_%2')
  return snake:lower()
end

local function ends_with(value, suffix)
  return suffix == '' or value:sub(-#suffix) == suffix
end

local function current_file_path(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == '' then
    return nil
  end

  return vim.fs.normalize(path)
end

local function project_root(path)
  local root = vim.fs.root(path, { 'mix.exs', '.git' })
  if root and root ~= '' then
    return root
  end

  local cwd = uv.cwd()
  if cwd and cwd ~= '' then
    return cwd
  end

  return vim.fn.getcwd()
end

local function find_top_level_module(bufnr)
  local modules = {}
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for line_nr, line in ipairs(lines) do
    local module_name = line:match '^defmodule%s+([%w_%.]+)'
    if module_name then
      table.insert(modules, { name = module_name, line = line_nr })
    end
  end

  if #modules == 0 then
    return nil, 'No top-level defmodule found in current buffer'
  end

  if #modules > 1 then
    return nil, string.format('Expected exactly one top-level defmodule, found %d', #modules)
  end

  return modules[1].name
end

local function detect_web_category(parts, web_index)
  for idx = web_index + 1, #parts do
    local part = parts[idx]
    if ends_with(part, 'Live') then
      return 'live'
    end

    if ends_with(part, 'Controller') or ends_with(part, 'HTML') or ends_with(part, 'JSON') then
      return 'controllers'
    end

    if ends_with(part, 'Component') then
      return 'components'
    end
  end

  return nil
end

local function module_to_relative_path(module_name)
  local parts = split_module(module_name)
  local is_test = ends_with(parts[#parts], 'Test')
  local root_dir = is_test and 'test' or 'lib'
  local extension = is_test and '.exs' or '.ex'
  local path_parts = {}
  local web_index = nil

  for idx, part in ipairs(parts) do
    if ends_with(part, 'Web') then
      web_index = idx
      break
    end
  end

  if web_index then
    for idx = 1, web_index do
      table.insert(path_parts, snake_case(parts[idx]))
    end

    if web_index < #parts then
      local category = detect_web_category(parts, web_index)
      if category then
        table.insert(path_parts, category)
      end

      for idx = web_index + 1, #parts do
        table.insert(path_parts, snake_case(parts[idx]))
      end
    end
  else
    for _, part in ipairs(parts) do
      table.insert(path_parts, snake_case(part))
    end
  end

  local filename = table.remove(path_parts)
  if not filename then
    return nil, string.format('Could not derive path from module %s', module_name)
  end

  local dir_parts = { root_dir }
  vim.list_extend(dir_parts, path_parts)
  local directory = join_paths(tbl_unpack(dir_parts))

  return join_paths(directory, filename .. extension)
end

local function rename_current_file()
  local bufnr = vim.api.nvim_get_current_buf()
  local source_path = current_file_path(bufnr)
  if not source_path then
    vim.notify('Current buffer has no file path', vim.log.levels.WARN)
    return
  end

  if vim.bo[bufnr].modified then
    vim.notify('Save the current buffer before aligning its file path', vim.log.levels.WARN)
    return
  end

  if not uv.fs_stat(source_path) then
    vim.notify('Current file does not exist on disk', vim.log.levels.WARN)
    return
  end

  local module_name, err = find_top_level_module(bufnr)
  if not module_name then
    vim.notify(err, vim.log.levels.WARN)
    return
  end

  local root = project_root(source_path)
  local target_relative_path, path_err = module_to_relative_path(module_name)
  if not target_relative_path then
    vim.notify(path_err, vim.log.levels.WARN)
    return
  end

  local target_path = vim.fs.normalize(join_paths(root, target_relative_path))
  if target_path == source_path then
    vim.notify('File already matches its module path', vim.log.levels.INFO)
    return
  end

  if uv.fs_stat(target_path) then
    vim.notify(string.format('Target already exists:\n%s\n->\n%s', source_path, target_path), vim.log.levels.ERROR)
    return
  end

  local target_dir = vim.fs.dirname(target_path)
  if vim.fn.mkdir(target_dir, 'p') == 0 then
    vim.notify('Failed to create target directory: ' .. target_dir, vim.log.levels.ERROR)
    return
  end

  if vim.fn.rename(source_path, target_path) ~= 0 then
    vim.notify(string.format('Failed to move file:\n%s\n->\n%s', source_path, target_path), vim.log.levels.ERROR)
    return
  end

  vim.cmd('keepalt file ' .. vim.fn.fnameescape(target_path))
  vim.notify('Aligned file path: ' .. target_relative_path, vim.log.levels.INFO)
end

local function ensure_user_command()
  if vim.fn.exists(':ElixirAlignFile') == 2 then
    return
  end

  vim.api.nvim_create_user_command('ElixirAlignFile', function()
    rename_current_file()
  end, { desc = 'Align current Elixir file path to its module name' })
end

ensure_user_command()

return {
  dir = vim.fn.stdpath 'config',
  name = 'elixir-align-file',
  ft = 'elixir',
  lazy = false,
}

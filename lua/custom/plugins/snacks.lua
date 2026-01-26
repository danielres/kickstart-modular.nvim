return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    gitbrowse = {},
    image = {},
    notifier = {},
    picker = {
      sources = {
        files = { layout = { fullscreen = true } },
        buffers = { layout = { fullscreen = true } },
      },
    },
    words = {
      enabled = true,
    },
    styles = {
      -- use entire screen space
      lazygit = { width = 0, height = 0 },
      scratch = { width = 0, height = 0 },

      terminal = {
        bo = {
          filetype = 'snacks_terminal',
        },
        wo = {},
        stack = true, -- when enabled, multiple split windows with the same position will be stacked together (useful for terminals)
        -- stylua: ignore
        keys = {
          -- Add window navigation keys
          ['<C-h>'] = { function() vim.cmd 'stopinsert' vim.cmd 'wincmd h' end, mode = 't' },
          ['<C-j>'] = { function() vim.cmd 'stopinsert' vim.cmd 'wincmd j' end, mode = 't' },
          ['<C-k>'] = { function() vim.cmd 'stopinsert' vim.cmd 'wincmd k' end, mode = 't' },
          ['<C-l>'] = { function() vim.cmd 'stopinsert' vim.cmd 'wincmd l' end, mode = 't' },
          ['<C-/>'] = { function() vim.cmd 'stopinsert' Snacks.terminal.toggle() end, mode = 't' },

            gf = function(self)
            local f = vim.fn.findfile(vim.fn.expand '<cfile>', '**')
            if f == '' then
              Snacks.notify.warn 'No file under cursor'
            else
              self:hide()
              vim.schedule(function()
                vim.cmd('e ' .. f)
              end)
            end
          end,

          term_normal = {
            '<esc>',
            function(self)
              self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
              if self.esc_timer:is_active() then
                self.esc_timer:stop()
                vim.cmd 'stopinsert'
              else
                self.esc_timer:start(200, 0, function() end)
                return '<esc>'
              end
            end,
            mode = 't',
            expr = true,
            desc = 'Double escape to normal mode',
          },
        },
      },
    },
    lazygit = {
      configure = true,
      theme_path = vim.fs.normalize(vim.fn.stdpath 'cache' .. '/lazygit-theme.yml'),
    },
    toggle = {},
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Create toggle mappings
        Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
        Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
        Snacks.toggle.diagnostics():map '<leader>ud'
        Snacks.toggle.line_number():map '<leader>ul'
        Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>uc'
        Snacks.toggle.treesitter():map '<leader>uT'
        -- Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
        Snacks.toggle.inlay_hints():map '<leader>uh'
        -- Snacks.toggle.indent():map '<leader>ug'
        Snacks.toggle.dim():map '<leader>uD'
        Snacks.toggle.zoom():map '<leader>bz'
      end,
    })
  end,
  -- stylua: ignore
  keys = {
    -- Command line: add vim modes support
    { ':', function() Snacks.input({ prompt = 'Command: ', completion = 'command', }, function(value) if value then vim.cmd(value) end end) end, desc = "Command" },

    -- Terminal
    { '<C-/>', function() Snacks.terminal.toggle() end, desc = '[T]oggle terminal' },

    -- Windows
    { '<leader>wn', function() Snacks.notifier.show_history() end, desc = '[D]elete' },

    -- Buffers
    { '<leader>.', function() Snacks.scratch() end, desc = 'Scratch' },
    { '<leader><leader>.', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer' },
    { '<leader>bd', function() Snacks.bufdelete() end, desc = '[D]elete' },
    { '<leader>bo', function() Snacks.bufdelete.other() end, desc = 'Delete [O]ther' },
    { '<leader>ba', function() Snacks.bufdelete.all() end, desc = 'Delete [A]ll' },
    { '<leader><leader>e', function() Snacks.explorer() end, desc = 'Explorer Snacks (root dir)' },

    -- Find
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<C-Space>", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    -- { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>ff", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },

    -- Git
    { '<leader>gg', function() Snacks.lazygit.open(require('snacks').config.lazygit) end, desc = 'Lazygit' },
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gw", function() Snacks.gitbrowse() end, desc = "Git Bro[w]se" },
    -- { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    -- { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    -- { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
 
    -- GitHub
    { '<leader>gGi', function() Snacks.picker.gh_issue() end, desc = 'GitHub Issues (open)' },
    { '<leader>gGI', function() Snacks.picker.gh_issue { state = 'all' } end, desc = 'GitHub Issues (all)' },
    { '<leader>gGp', function() Snacks.picker.gh_pr() end, desc = 'GitHub Pull Requests (open)' },
    { '<leader>gGP', function() Snacks.picker.gh_pr { state = 'all' } end, desc = 'GitHub Pull Requests (all)' },
    -- { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
    -- { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
    -- { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
    -- { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },

    -- Grep
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },

    -- Search
    { "<leader>sn", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    -- { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },

    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
    { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
    { "<localleader>d", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "<localleader>d", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "<localleader>D", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "<localleader>r", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "<localleader>I", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "<localleader>y", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "<localleader>ai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
    { "<localleader>ao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

    -- Words
    { "]]", function() Snacks.words.jump() end, desc = "Words: jump" },
    { "[[", function() Snacks.words.jump(-1) end, desc = "Words: jump backwards" },
  },
}

return {
  'neovim/nvim-lspconfig',
  init = function()
    local group = vim.api.nvim_create_augroup('elixirls-pipe-maps', { clear = true })

    vim.api.nvim_create_autocmd('LspAttach', {
      group = group,
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client or client.name ~= 'elixirls' then
          return
        end

        local function manipulate(direction)
          local params = {
            command = 'manipulatePipes:' .. (client.id or '1'),
            arguments = {
              direction,
              vim.uri_from_bufnr(event.buf),
              vim.fn.line '.' - 1,
              vim.fn.col '.' - 1,
            },
          }

          vim.lsp.buf_request(event.buf, 'workspace/executeCommand', params)
        end

        vim.keymap.set('n', '<localleader>tp', function()
          manipulate('toPipe')
        end, { buffer = event.buf, desc = '[T]o [P]ipe' })

        vim.keymap.set('n', '<localleader>fp', function()
          manipulate('fromPipe')
        end, { buffer = event.buf, desc = '[F]rom [P]ipe' })
      end,
    })
  end,
}


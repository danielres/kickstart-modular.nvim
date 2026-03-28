return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  build = ':Copilot auth',
  event = 'BufReadPost',
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = '<M-enter>', -- or your preferred key
        next = '<M-]>',
        prev = '<M-[>',
      },
    },
    panel = {
      enabled = true,
      keymap = {
        open = '<C-j>', -- panel open keymap goes here
      },
    },
    filetypes = {
      markdown = true,
      help = true,
    },
  },
}

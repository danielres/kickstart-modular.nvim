-- Telescope mappings
-- f 	<c-f> 	find_project_files
-- b 	<c-b> 	browse_project_files
-- d 	<c-d> 	delete_project
-- s 	<c-s> 	search_in_project_files
-- r 	<c-r> 	recent_project_files
-- w 	<c-w> 	change_working_directory

return {
  'ahmedkhalf/project.nvim',
  opts = {
    manual_mode = false,
    patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', '.obsidian' },
    detection_methods = { 'pattern', 'lsp' },
  },
  event = 'VeryLazy',
  config = function(_, opts)
    require('project_nvim').setup(opts)

    local history = require 'project_nvim.utils.history'

    history.delete_project = function(project)
      for k, v in pairs(history.recent_projects) do
        if v == project.value then
          history.recent_projects[k] = nil
          return
        end
      end
    end
  end,
}

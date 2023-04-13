require('wouldgo.utils.reload')

local function reload()
  local function get_module_name(s)
    local module_name;

    module_name = s:gsub("%.lua", "")
    module_name = module_name:gsub("%/", ".")
    module_name = module_name:gsub("%.init", "")

    return module_name
  end

  local prompt_title = "~ neovim modules ~"

  local path = "~/.config/nvim/lua"

  local opts = {
    prompt_title = prompt_title,
    cwd = path,

    attach_mappings = function(_, map)
     -- ctrl+e.
      map("i", "<c-e>", function(_)
        local entry = require("telescope.actions.state").get_selected_entry()
        local name = get_module_name(entry.value)

        R(name)
        P(name .. " reloaded!!!")
      end)

      return true
    end
  }

  require('telescope.builtin').find_files(opts)
end

vim.keymap.set('n', '<leader>qr', reload, { noremap = true, silent = true })

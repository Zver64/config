---@module 'snacks'
return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = function(_, opts)
    local translate_key = require("langmapper.utils").translate_keycode
    local normkey_orig = Snacks.util.normkey
    Snacks.util.normkey = function(key)
      if key then
        key = translate_key(key, "default", "ru")
      end
      return normkey_orig(key)
    end
    return vim.tbl_deep_extend("force", opts, {
      picker = {
        actions = {
          delete_projects = function(picker, _)
            Snacks.picker.actions.close(picker)
            local items = picker:selected({ fallback = true })
            vim.defer_fn(function()
              vim.cmd("edit " .. vim.fn.stdpath("state") .. "/shada/main.shada")
              for _, item in ipairs(items) do
                local regex = "^\\S\\(\\n\\s\\|[^\\n]\\)\\{-}"
                  .. vim.fn.escape(item.file, "/\\")
                  .. "\\_.\\{-}\\n*\\ze\\(^\\S\\|\\%$\\)"
                vim.cmd("%s/" .. regex .. "//g")
              end
              vim.cmd("write!")
              vim.cmd("rshada!")
              vim.cmd("bwipeout!")
              Snacks.picker.projects()
            end, 100)
          end,
        },
        sources = {
          files = {
            hidden = true,
          },
          explorer = {
            hidden = true,
          },
          grep = {
            hidden = true,
          },
          grep_word = {
            hidden = true,
          },
          projects = {
            win = {
              input = {
                keys = {
                  ["<C-x>"] = { "delete_projects", mode = { "n", "i" } },
                },
              },
            },
          },
        },
      },
    })
  end,
}

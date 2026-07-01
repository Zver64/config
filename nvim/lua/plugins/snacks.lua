---@module 'snacks'
return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    image = {
      doc = {
        -- Keep automatic inline rendering limited to Markdown via the autocmd below.
        enabled = false,
        inline = true,
        float = false,
        max_width = 45,
        max_height = 18,
      },
    },
    picker = {
      layout = {
        preset = "vertical",
      },
      layouts = {
        vertical = {
          layout = {
            width = 0.9,
            [3] = { height = 0.7 },
          },
        },
      },
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
          ignored = true,
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
  },
  keys = {
    {
      "<leader>ih",
      function()
        Snacks.image.hover()
      end,
      desc = "Show Image Under Cursor",
    },
    {
      "<leader>iH",
      function()
        Snacks.image.doc.hover_close()
      end,
      desc = "Close Image Preview",
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_snacks_markdown_images", { clear = true }),
      pattern = { "markdown", "markdown.mdx" },
      callback = function(event)
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(event.buf) then
            Snacks.image.doc.attach(event.buf)
          end
        end)
      end,
    })
  end,
}

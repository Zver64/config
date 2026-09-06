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
      previewers = {
        diff = {
          style = "terminal",
        },
      },
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
        git_grep_hunks = {
          supports_live = false,
          format = function(item, picker)
            local file_format = Snacks.picker.format.file(item, picker)
            vim.api.nvim_set_hl(0, "SnacksPickerGitGrepLineNew", { link = "Added" })
            vim.api.nvim_set_hl(0, "SnacksPickerGitGrepLineOld", { link = "Removed" })
            if item.sign == "+" then
              file_format[#file_format - 1][2] = "SnacksPickerGitGrepLineNew"
            else
              file_format[#file_format - 1][2] = "SnacksPickerGitGrepLineOld"
            end
            return file_format
          end,
          finder = function(_, ctx)
            local hcount = 0
            local header = {
              file = "",
              old = { start = 0, count = 0 },
              new = { start = 0, count = 0 },
            }
            local sign_count = 0
            return require("snacks.picker.source.proc").proc(
              ctx:opts({
                cmd = "git",
                args = { "diff", "--unified=0" },
                transform = function(item) ---@param item snacks.picker.finder.Item
                  local line = item.text
                  -- [[Header]]
                  if line:match("^diff") then
                    hcount = 3
                  elseif hcount > 0 then
                    if hcount == 1 then
                      header.file = line:sub(7)
                    end
                    hcount = hcount - 1
                  elseif line:match("^@@") then
                    local parts = vim.split(line:match("@@ ([^@]+) @@"), " ")
                    local old_start, old_count = parts[1]:match("-(%d+),?(%d*)")
                    local new_start, new_count = parts[2]:match("+(%d+),?(%d*)")
                    header.old.start, header.old.count = tonumber(old_start), tonumber(old_count) or 1
                    header.new.start, header.new.count = tonumber(new_start), tonumber(new_count) or 1
                    sign_count = 0
                  -- [[Body]]
                  elseif not line:match("^[+-]") then
                    sign_count = 0
                  elseif line:match("^[+-]%s*$") then
                    sign_count = sign_count + 1
                  else
                    item.sign = line:sub(1, 1)
                    item.file = header.file
                    item.line = line:sub(2)
                    if item.sign == "+" then
                      item.pos = { header.new.start + sign_count, 0 }
                      sign_count = sign_count + 1
                    else
                      item.pos = { header.new.start, 0 }
                      sign_count = 0
                    end
                    return true
                  end
                  return false
                end,
              }),
              ctx
            )
          end,
        },
      },
    },
  },
  keys = {
    {
      "<leader>ss",
      function()
        Snacks.picker.git_grep_hunks()
      end,
      desc = "Git Grep Hunks",
    },
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

local M = {}

local function ensure_code_window()
  local ft = vim.bo.filetype
  if ft == "neo-tree" or ft == "toggleterm" then
    vim.cmd("wincmd l")
  end
end

function M.setup()
  vim.api.nvim_create_autocmd("CmdlineEnter", {
    pattern = ":",
    callback = ensure_code_window,
  })

  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      vim.defer_fn(function()
        local args = vim.fn.argv()
        if #args == 0 then
          return
        end
        
        if #args == 1 and vim.fn.isdirectory(args[1]) == 1 then
          -- Skip Neo-tree
        else
          vim.cmd("Neotree filesystem show left")
        end

        vim.cmd("ToggleTerm")
      end, 50)
    end,
  })

  vim.api.nvim_create_autocmd("BufLeave", {
    pattern = "*",
    once = true,
    callback = function()
      if vim.bo.filetype == "dashboard" then
        vim.defer_fn(function()
          vim.cmd("Neotree filesystem show left")
          vim.cmd("ToggleTerm")
        end, 50)
      end
    end,
  })

  vim.api.nvim_create_user_command("XSaveAll", function()
    if vim.lsp.stop_client then
      for _, client in pairs(vim.lsp.get_active_clients()) do
        vim.lsp.stop_client(client.id)
      end
    end
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].buftype == "terminal" then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
    vim.cmd("wa")
    vim.cmd("xa")
  end, {})

  vim.cmd([[
    cnoreabbrev <expr> q getcmdtype() == ":" && getcmdline() == 'q' ? 'qa!' : 'q!'
    cnoreabbrev <expr> x getcmdtype() == ":" && getcmdline() == 'x' ? 'XSaveAll' : 'x'
  ]])
end

return M


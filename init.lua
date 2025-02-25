vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = ' '

vim.cmd([[
  cnoreabbrev <expr> q! getcmdtype() == ":" && getcmdline() == 'q!' ? 'qa!' : 'q!'
]])
vim.cmd([[
  tnoremap <Esc> <C-\><C-n>
]])

-- NORMAL mode: move the current line up/down
vim.keymap.set('n', '<C-S-Up>',   ':m .-2<CR>==', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-Down>', ':m .+1<CR>==', { noremap = true, silent = true })

-- VISUAL mode: move the highlighted lines up/down
vim.keymap.set('v', '<C-S-Up>',   ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', '<C-S-Down>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(function()
      vim.cmd("ToggleTerm")
      local args = vim.fn.argv()
      if #args == 1 and vim.fn.isdirectory(args[1]) == 1 then
        -- Skip Neo-tree
      else
        vim.cmd("Neotree filesystem show left")
      end
    end, 50)
  end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons",       
          "MunifTanjim/nui.nvim",
      },
    },
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      config = function()
        require("toggleterm").setup{
          size = 10,
          open_mapping = [[<c-\>]],
          direction = "horizontal",
          shade_terminals = false,
          start_in_insert = true,
          persist_size = true,
          close_on_exit = true,
          dir = function()
            return vim.fn.getcwd()
          end,  
      }
      end,
    },
    {
      'romgrk/barbar.nvim',
      dependencies = {
        'lewis6991/gitsigns.nvim',
        'nvim-tree/nvim-web-devicons',
      },
      init = function() vim.g.barbar_auto_setup = false end,
      opts = {},
      version = '^1.0.0',
    },
    {
      "ahmedkhalf/project.nvim",
      config = function()
      require("project_nvim").setup({
        manual_mode = true,
        detection_methods = { "lsp", "pattern" },
        patterns = { ".git", "package.json", "Makefile", "README.md" },
      })

      local status_ok, telescope = pcall(require, "telescope")
      if status_ok then
      telescope.load_extension("projects")
      end
      end,
    },
}
local opts = {}

require("lazy").setup(plugins, opts)

local builtin = require("telescope.builtin")
vim.api.nvim_set_keymap("x", "<Tab>", ">gv",   { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<S-Tab>", "<gv", { noremap = true, silent = true })
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>')

local config = require("nvim-treesitter.configs")
config.setup({
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
  highlight = { enable = true },
  indent = { enable = true },
})

require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"


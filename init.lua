vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")   
vim.opt.clipboard = "unnamedplus"

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(function()
      local args = vim.fn.argv()
      if #args == 0 then
        return
      end
      vim.cmd("ToggleTerm")
      if #args == 1 and vim.fn.isdirectory(args[1]) == 1 then
        -- Skip Neo-tree
      else
        vim.cmd("Neotree filesystem show left")
      end
    end, 50)
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "*",
  once = true,
  callback = function()
    if vim.bo.filetype == "dashboard" then
      vim.defer_fn(function()
        vim.cmd("ToggleTerm")
        vim.cmd("Neotree filesystem show left")
      end, 50)
    end
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
    {
      'glepnir/dashboard-nvim',
      event = 'VimEnter',
      config = function()
        require('dashboard').setup {
          theme = 'hyper',
          config = {
          header = {
        "                                                               ",
        "                                                               ",
        "                                                               ",
        "                                                               ",
        " ▄████████  ▄██████▄    ▄▄▄▄███▄▄▄▄      ▄████████             ",
        "███    ███ ███    ███ ▄██▀▀▀███▀▀▀██▄   ███    ███             ",
        "███    █▀  ███    ███ ███   ███   ███   ███    █▀              ",
        "███        ███    ███ ███   ███   ███  ▄███▄▄▄                 ",
        "███        ███    ███ ███   ███   ███ ▀▀███▀▀▀                 ",
        "███    █▄  ███    ███ ███   ███   ███   ███    █▄              ",
        "███    ███ ███    ███ ███   ███   ███   ███    ███             ",
        "████████▀   ▀██████▀   ▀█   ███   █▀    ██████████             ",
        "                                                                ",
        " ▄██████▄  ███▄▄▄▄        ▄██   ▄    ▄██████▄  ███    █▄        ",
        "███    ███ ███▀▀▀██▄      ███   ██▄ ███    ███ ███    ███       ",
        "███    ███ ███   ███      ███▄▄▄███ ███    ███ ███    ███       ",
        "███    ███ ███   ███      ▀▀▀▀▀▀███ ███    ███ ███    ███       ",
        "███    ███ ███   ███      ▄██   ███ ███    ███ ███    ███       ",
        "███    ███ ███   ███      ███   ███ ███    ███ ███    ███       ",
        "███    ███ ███   ███      ███   ███ ███    ███ ███    ███       ",
        " ▀██████▀   ▀█   █▀        ▀█████▀   ▀██████▀  ████████▀        ",
        "                                                                ",
        "   ▄████████    ▄███████▄ ███    █▄     ▄████████    ▄████████  ",
        "  ███    ███   ███    ███ ███    ███   ███    ███   ███    ███  ",
        "  ███    █▀    ███    ███ ███    ███   ███    ███   ███    █▀   ",
        "  ███          ███    ███ ███    ███  ▄███▄▄▄▄██▀   ███          ",
        "▀███████████ ▀█████████▀  ███    ███ ▀▀███▀▀▀▀▀   ▀███████████  ",
        "         ███   ███        ███    ███ ▀███████████          ███  ",
        "   ▄█    ███   ███        ███    ███   ███    ███    ▄█    ███  ",
        " ▄████████▀   ▄████▀      ████████▀    ███    ███  ▄████████▀   ",
        "                                       ███    ███               ",
      },
        center = {
          { icon = " ", desc = " Find File", action = "Telescope find_files", key = "f" },
          { icon = " ", desc = " Recent Files", action = "Telescope oldfiles", key = "r" },
          { icon = " ", desc = " Find Word", action = "Telescope live_grep", key = "g" },
          { icon = " ", desc = " Restore Session", action = "SessionLoad", key = "s" },
        },
        footer = { "Europa League Champions 2024/25" }
      }
    }
    end
  },
  {
    'tpope/vim-commentary' 
  }
}

local opts = {}

require("lazy").setup(plugins, opts)

local builtin = require("telescope.builtin")
vim.api.nvim_set_keymap("x", "<Tab>", ">gv",   { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<S-Tab>", "<gv", { noremap = true, silent = true })
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>')
vim.keymap.set('n', '<D-a>', 'ggVG', { noremap = true, silent = true })

vim.keymap.set({'n', 'x', 'o'}, 'H', '^')
vim.keymap.set({'n', 'x', 'o'}, 'L', '$')

vim.keymap.set({"n", "v", "o"}, "<C-c>", "\"+y<Esc>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-c>", "V\"+y", { noremap = true, silent = true })

-- Paste from system clipboard in NORMAL and VISUAL modes:
vim.keymap.set({"n", "v"}, "<C-v>", '"+p', { noremap = true, silent = true })

-- Map Cmd+Z to undo (the same behavior as Ctrl+Z)
vim.keymap.set('n', '<D-z>', '<C-z>', { noremap = true, silent = true })  -- Normal mode
vim.keymap.set('v', '<D-z>', '<C-z>', { noremap = true, silent = true })  -- Visual mode

-- in insert mode, exit insert mode, paste, and return to insert:
vim.keymap.set("i", "<C-v>", '<esc>"+pa', { noremap = true, silent = true })

-- undo in normal/ visual with command + z
vim.keymap.set({'n','v'}, '<C-z>', 'u', { noremap = true, silent = true })

vim.keymap.set("n", "<D-f>", function()
  local ft = vim.bo.filetype
  if ft == "toggleterm" or ft == "neo-tree" then
    print("Search is disabled in this buffer")
    return
  end
  require("telescope.builtin").current_buffer_fuzzy_find({
    initial_mode = "insert",
    prompt_title = "Search in Current File",
  })
end, { desc = "File-wide Search" })

vim.keymap.set("n", "<D-S-f>", function()
  require("telescope.builtin").live_grep({
    search_dirs = { vim.fn.getcwd() },
    prompt_title = "Directory-wide Search"
  })
end, { desc = "Directory-wide Search" })

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

-- NORMAL mode: duplicate the current line above/below
-- <D-Up>   -> yank this line, then paste above
-- <D-Down> -> yank this line, then paste below
vim.keymap.set('n', '<D-Up>',   'yyP', { noremap = true, silent = true })
vim.keymap.set('n', '<D-Down>', 'yyp', { noremap = true, silent = true })
-- VISUAL mode: move the highlighted lines up/down
vim.keymap.set('v', '<D-Down>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', '<D-Up>',   ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

vim.keymap.set("n", "<D-S-Up>", "Vk", { noremap = true, silent = true })
vim.keymap.set("n", "<D-S-Down>", "Vj", { noremap = true, silent = true })
vim.keymap.set("v", "<D-S-Up>", "k", { noremap = true, silent = true })
vim.keymap.set("v", "<D-S-Down>", "j", { noremap = true, silent = true })

vim.keymap.set("n", "<D-S-Left>", "vh", { noremap = true, silent = true })
vim.keymap.set("n", "<D-S-Right>", "vl", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<D-S-Left>', 'h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<D-S-Right>', 'l', { noremap = true, silent = true })

local config = require("nvim-treesitter.configs")
config.setup({
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
  highlight = { enable = true },
  indent = { enable = true },
})

require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"


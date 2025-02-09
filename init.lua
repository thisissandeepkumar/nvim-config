-- Install Packer plugins
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'        -- Packer can manage itself
    use 'nvim-treesitter/nvim-treesitter' -- Treesitter for syntax highlighting
    use 'neovim/nvim-lspconfig'         -- LSP (Language Server Protocol)
    use 'hrsh7th/nvim-cmp'              -- Autocompletion
    use 'hrsh7th/cmp-nvim-lsp'          -- LSP source for nvim-cmp
    use 'L3MON4D3/LuaSnip'              -- Snippets
    use 'nvim-telescope/telescope.nvim' -- Fuzzy finder
    use 'nvim-lualine/lualine.nvim'     -- Statusline
    use 'kyazdani42/nvim-tree.lua'      -- File Explorer
    use 'lewis6991/gitsigns.nvim'       -- Git integration
    use 'gruvbox-community/gruvbox'    -- Gruvbox colorscheme
    use 'mfussenegger/nvim-dap'
    use 'rcarriga/nvim-dap-ui'
end)

-- Basic Neovim settings
vim.o.number = true                    -- Show line numbers
vim.o.relativenumber = true            -- Relative line numbers
vim.o.tabstop = 4                      -- Tab size
vim.o.shiftwidth = 4                   -- Indent size
vim.o.expandtab = true                 -- Convert tabs to spaces
vim.o.smartindent = true               -- Smart indentation
vim.o.wrap = false                     -- Disable line wrapping
vim.o.termguicolors = true             -- Enable true colors

-- Colorscheme setup
vim.cmd('colorscheme gruvbox')
vim.o.background = 'dark'

-- Key mappings
vim.api.nvim_set_keymap('n', '<C-p>', ':Telescope find_files<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true })

-- Treesitter setup (including automatic installation of parsers)
require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "cpp", "lua", "python" }, -- Add more languages as needed
    highlight = {
        enable = true,                                 -- Enable syntax highlighting
    },
    incremental_selection = {
        enable = true,
    },
}

-- Automatically install missing Treesitter parsers
vim.cmd([[ 
    autocmd BufEnter * :TSUpdate
]])

-- LSP configuration with automatic setup for language servers
local lspconfig = require('lspconfig')

-- Define servers to install
local servers = { "clangd", "pyright" }

-- Install missing LSP servers (requires npm globally)
for _, server in ipairs(servers) do
    if not lspconfig[server] then
        print("Installing missing LSP server: " .. server)
    end
    lspconfig[server].setup {}
end

-- Statusline setup
require('lualine').setup()

-- File Explorer setup
require('nvim-tree').setup()

-- Colorscheme setup with safe fallback
local colorscheme = "gruvbox"
local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not ok then
    vim.notify("Colorscheme " .. colorscheme .. " not found! Defaulting to 'default'.", vim.log.levels.WARN)
    vim.cmd("colorscheme default") -- Fallback to default
end

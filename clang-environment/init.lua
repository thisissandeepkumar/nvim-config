-- Install Packer plugins
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'        -- Packer can manage itself
    use 'nvim-treesitter/nvim-treesitter' -- Treesitter for syntax highlighting
    use 'neovim/nvim-lspconfig'         -- LSP (Language Server Protocol)
    use 'hrsh7th/nvim-cmp'              -- Autocompletion
    use 'hrsh7th/cmp-nvim-lsp'          -- LSP source for nvim-cmp
    use 'L3MON4D3/LuaSnip'              -- Snippets
    use 'saadparwaiz1/cmp_luasnip'      -- Snippet source for nvim-cmp
    use 'nvim-telescope/telescope.nvim' -- Fuzzy finder
    use 'nvim-lualine/lualine.nvim'     -- Statusline
    use 'kyazdani42/nvim-tree.lua'      -- File Explorer
    use 'lewis6991/gitsigns.nvim'       -- Git integration
    use 'gruvbox-community/gruvbox'    -- Gruvbox colorscheme
    use 'mfussenegger/nvim-dap'         -- Debug Adapter Protocol
    use 'rcarriga/nvim-dap-ui'          -- Debug UI for DAP
    use 'nvim-neotest/nvim-nio'         -- Required for nvim-dap-ui
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
require('lualine').setup {
    options = {
        theme = 'gruvbox',
        section_separators = '',
        component_separators = '|',
    },
}

-- File Explorer setup
require('nvim-tree').setup {
    view = {
        width = 30,
        side = 'left',
    },
}

-- Gitsigns Configuration
require('gitsigns').setup {
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
    },
}

-- Colorscheme setup with safe fallback
local colorscheme = "gruvbox"
local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not ok then
    vim.notify("Colorscheme " .. colorscheme .. " not found! Defaulting to 'default'.", vim.log.levels.WARN)
    vim.cmd("colorscheme default") -- Fallback to default
end

-- Setup nvim-cmp
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `LuaSnip` users.
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item.
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- LSP-based completions
    { name = 'luasnip' },  -- Snippet completions
  }, {
    { name = 'buffer' },   -- Buffer-based completions
    { name = 'path' },     -- File path completions
  })
})

-- Use buffer source for `/` and `?`
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for `:`
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Debugging (nvim-dap) Configuration
local dap = require('dap')
local dapui = require('dapui')

dapui.setup()
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end

-- LSP Setup
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig').clangd.setup {
  capabilities = capabilities,
}

-- Keybinding to compile and run main.cpp
vim.api.nvim_set_keymap(
  'n', 
  '<leader>r', 
  ':w<CR>:!g++ -std=c++17 % -o %:r && ./%:r<CR>', 
  { noremap = true, silent = true }
)

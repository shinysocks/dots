---------------------
--  NEOVIM CONFIG  --
---------------------

-- lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        { "catppuccin/nvim",                 name = "catppuccin",                 priority = 1000 },
        { "nvim-telescope/telescope.nvim",   tag = '0.1.8',                       dependencies = { 'nvim-lua/plenary.nvim' } },
        { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
        { "williamboman/mason.nvim",         "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
        { "hrsh7th/cmp-nvim-lsp",            "hrsh7th/nvim-cmp",                  "hrsh7th/cmp-vsnip", },
        { "m4xshen/autoclose.nvim", },
        { "nvim-lualine/lualine.nvim" },
    },

    checker = { enabled = true, notify = false },
})

vim.diagnostic.config({ virtual_text = true })

-- autoclose setup
require("autoclose").setup({
    options = {
        disabled_filetypes = { "text", "latex", "texlab", "tex", "nix" },
        pair_spaces = true,
        auto_indent = true,
    },
})

-- mason / lsp setup
require('mason').setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

local lsp_servers = {
    'bashls', 'kotlin_lsp', 'cssls',
    'html', 'jsonls', 'lua_ls',
    'texlab', 'yamlls', 'jdtls', 'ts_ls', 'rust-analyzer'
}

require("mason-lspconfig").setup {
    ensure_installed = lsp_servers,
    automatic_installation = true,
}

vim.lsp.config('*', {
    root_markers = { '.git' },
})

vim.lsp.enable(lsp_servers)

local cmp = require('cmp')
cmp.setup {
    sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'vsnip' },
    },
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
}

-- treesitter
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash", "c", "c_sharp", "cpp", "css", "csv", "dockerfile", "git_config", "gitcommit",
        "gitignore", "html", "http", "java", "javascript", "json", "latex", "lua", "markdown",
        "nginx", "python", "robots", "sql", "ssh_config", "toml", "typescript", "vim", "xml",
        "yaml", "kotlin", "asm", "nix", "rust"
    },
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
})

-- lualine
require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = 'auto',
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
            statusline = 500,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = {
            'branch',
            {
                'diagnostics',
                symbols = { error = '⏹ ', warn = '', info = '', hint = '' },
            },
        },
        lualine_c = {
            {
                'filename',
                symbols = {
                    modified = '●',
                    readonly = '-',
                    unnamed = 'unnamed',
                    newfile = 'new',
                },
            },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
}

-- customize catppuccin theme
require("catppuccin").setup({
    flavour = "mocha",
    color_overrides = {
        all = {
            base = "#000000",
        }
    },

    integrations = {
        telescope = { enabled = true },
        mason = { enabled = true },
    },

    float = {
        transparent = true,
        solid = true,
    },

    show_end_of_buffer = false,
    term_colors = true,
    dim_inactive = {
        enabled = true,
        shade = "transparent_background",
        percentage = 0.15,
    },

    no_italic = false,
    no_bold = false,
    no_underline = false,
    default_integrations = true
}
)

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argv(0) == "" or vim.fn.argv(0) == "." then
            vim.cmd("Telescope find_files hidden=true")
        end
    end,
})

vim.cmd.colorscheme "catppuccin-mocha"
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.statusline = '3'
vim.opt.signcolumn = 'no'
vim.o.winborder = 'rounded'

-- terminal
vim.api.nvim_command("autocmd TermOpen * startinsert")
vim.api.nvim_command("autocmd TermOpen * setlocal nonumber")
vim.api.nvim_command("autocmd TermEnter * setlocal signcolumn=no")

-- custom keybindings
vim.keymap.set("n", "<leader>f", "<Cmd>Telescope find_files hidden=true<CR>");
vim.keymap.set("n", "<leader>g", "<Cmd>Telescope live_grep hidden=true<CR>");
vim.keymap.set('t', '<esc>', "<C-\\><C-n>") -- fix terminal escape
vim.keymap.set("n", "<leader>n", "<Cmd>lua vim.diagnostic.goto_next()<CR>");
vim.keymap.set("n", "<leader>N", "<Cmd>lua vim.diagnostic.goto_prev()<CR>");
vim.keymap.set("n", "U", "<Cmd>redo<CR>");
vim.keymap.set("n", "E", "$");
vim.keymap.set("v", "E", "$");
vim.keymap.set("n", "dE", "d$");
vim.keymap.set('n', '<leader>b', '<C-6>', {}) -- switch to previous
vim.keymap.set('n', 't', '<C-w>', {})
vim.keymap.set('n', 'th', '<C-w>s', {})
vim.keymap.set('n', '<leader>y', '"+y', {})
vim.keymap.set('v', '<leader>y', '"+y', {})
vim.keymap.set('n', '<leader>p', '"+p', {})

vim.keymap.set('n', 'gk', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
vim.keymap.set('n', 'gF', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

-- Learning --
-- * global rename gr
-- * format file
-- * REPLACE mode
-- * gk for hover instead of space

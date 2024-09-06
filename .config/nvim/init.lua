
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
      { out, "WarningMsg" },
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
    -- plugins go here
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "nvim-telescope/telescope.nvim", tag = '0.1.8', dependencies = { 'nvim-lua/plenary.nvim' } },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
    { "VonHeikemen/lsp-zero.nvim", branch = 'v4.x'},
    { "hrsh7th/cmp-nvim-lsp", },
    { "hrsh7th/nvim-cmp", "hrsh7th/cmp-vsnip", },
    { "m4xshen/autoclose.nvim", },
  },
  checker = { enabled = true },
})

-- autoclose setup
require("autoclose").setup({
  options = {
    disabled_filetypes = { "text" },
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

local lsp_zero = require('lsp-zero')
local cmp = require('cmp')
local lsp_servers = { 'bashls', 'cssls', 'denols', 'docker_compose_language_service', 'dockerls', 'html', 'jsonls', 'lua_ls', 'grammarly', 'pylsp', 'rust_analyzer', 'texlab', 'yamlls', 'jdtls' }


local lsp_attach = function(_, bufnr)
  local opts = {buffer = bufnr}

  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
end

lsp_zero.extend_lspconfig({
  sign_text = true,
  lsp_attach = lsp_attach,
})

lsp_zero.on_attach(function(_, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require("mason-lspconfig").setup {
  ensure_installed = lsp_servers,
  automatic_installation = true,

  handlers = {
    lsp_zero.default_setup,
  },
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- language servers
require('lspconfig').jdtls.setup {
  capabilities = capabilities,
  on_attach = lsp_attach,
}

require('lspconfig').denols.setup {
  capabilities = capabilities,
  on_attach = lsp_attach,
}

require('lspconfig').html.setup {
  capabilities = capabilities,
  on_attach = lsp_attach,
}

require('lspconfig').lua_ls.setup {
  capabilities = capabilities,
  on_attach = lsp_attach,
}

require('lspconfig').texlab.setup {
  capabilities = capabilities,
  on_attach = lsp_attach,
}

require('lspconfig').pylsp.setup {
  capabilities = capabilities,
  on_attach = lsp_attach,
}

require('lspconfig').rust_analyzer.setup {
  capabilities = capabilities,
  on_attach = lsp_attach,
}

require('lspconfig').cssls.setup {
  capabilities = capabilities,
  on_attach = lsp_attach,
}

cmp.setup {
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'vsnip' },
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- because we are using the vsnip cmp plugin
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


-- telescope keybinds
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})


-- treesitter
require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },
})


-- customize catppuccin theme
require("catppuccin").setup({
    flavour = "mocha",
    color_overrides = {},
    integrations = {
	telescope = { enabled = true },
 	mason = { enabled = true },
    },
    transparent_background = true,
    show_end_of_buffer = false,
    term_colors = true,
    dim_inactive = {
        enabled = true,
        shade = "dark",
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
      require("telescope.builtin").find_files()
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


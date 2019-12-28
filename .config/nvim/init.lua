--- =====================================================
--- Plugins
--- =====================================================
require('plugins')

--- =====================================================
--- General settings
--- =====================================================

local options = {
  cursorline = true,
  cursorcolumn = true,
  updatetime = 200,
  relativenumber = true,
  termguicolors = true,
  wrap = false
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd([[
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
]])

--- =====================================================
--- Themes
--- =====================================================

vim.cmd[[colorscheme molokai]]
vim.cmd[[highlight SignColumn ctermbg=none guibg=none]]
vim.cmd[[highlight LineNr ctermbg=none guibg=none]]

--- =====================================================
--- vim-bookmarks
--- =====================================================
vim.g.bookmark_sign = '♥'
vim.g.bookmark_highlight_lines = 1
vim.g.bookmark_center = 1
vim.g.bookmark_auto_close = 1

--- =====================================================
--- fzf-lua settings
--- =====================================================
local actions = require('fzf-lua.actions')

require('fzf-lua').setup({
  winopts = {
    hl = {
      border = 'FloatBorder',
    },
  },
  preview = {
    layout = 'vertical'
  },
  fzf_opts = {
    ['--border'] = 'none',
  },
  previewers = {
    builtin = {
      scrollbar = false,
    },
  },
  grep = {
    actions = {
      ['default'] = actions.file_edit_or_qf,
      ['ctrl-q'] = actions.file_sel_to_qf,
    },
  },
  buffers = {
    git_icons = false,
    actions = {
      ['ctrl-w'] = actions.buf_del,
      ['ctrl-q'] = actions.file_sel_to_qf,
    },
  },
  files = {
    fd_opts = [[--color never --type f --hidden --follow --strip-cwd-prefix]],
    git_icons = true,
    keymap= '<C-p>',
    actions = {
      ['default'] = actions.file_edit,
      ['ctrl-q'] = actions.file_sel_to_qf,
    },
  }
})

vim.api.nvim_set_keymap("n", "<C-p>", [[<Cmd>lua require"fzf-lua".files()<CR>]], {})
vim.api.nvim_set_keymap("n", "<C-n>", [[<Cmd>lua require"fzf-lua".buffers()<CR>]], {})
vim.api.nvim_set_keymap("n", "<C-f>", [[<Cmd>lua require"fzf-lua".live_grep()<CR>]], {})

--- =====================================================
--- which-key settings
--- =====================================================
vim.o.timeout = true
vim.o.timeoutlen = 50
require("which-key").setup({})

--- =====================================================
--- gitsigns settings
--- =====================================================
require('gitsigns').setup({
  signs = {
	  add = {text="+"},
	  change = {text="~"},
	  delete = {text="-"},
	  changedelete = {text="~"},
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map('n', 'ghs', gs.stage_hunk)
    map('n', 'ghu', gs.reset_hunk)
    map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', 'ghp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')

    vim.api.nvim_set_hl(0, "GitSignsAdd", {fg="#a6e22e", bg="none"})
    vim.api.nvim_set_hl(0, "GitSignsChange", {fg="#fd971f", bg="none"})
    vim.api.nvim_set_hl(0, "GitSignsDelete", {fg="#f92672", bg="none"})
  end
})

--- =====================================================
--- lualine settings
--- =====================================================
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

--- =====================================================
--- bufferline settings
--- =====================================================
require("bufferline").setup({
	options = {
		diagnostics = "nvim_lsp"
	}
})

--- =====================================================
--- bufferline settings
--- =====================================================
require("fidget").setup({})

--- =====================================================
--- neodev settings
--- =====================================================
require("neodev").setup({})

--- =====================================================
--- LSP settings
--- =====================================================
local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set('n', '<leader>bf', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

    vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts) 
  end
})

local default_setup = function(server)
  lspconfig[server].setup({})
end

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {"clangd", "lua_ls", "pyright", "marksman"},
  handlers = {
    default_setup,
  },
})

local cmp = require('cmp')

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
  },
  mapping = cmp.mapping.preset.insert({
    -- Enter key confirms completion item
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    -- Ctrl + space triggers completion menu
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})

--- =====================================================
--- nvim-web-devicons settings
--- =====================================================
require("nvim-web-devicons").setup({})

--- =====================================================
--- shade settings
--- =====================================================
require("shade").setup({
	overlay_opacity = 80,
	opacity_step = 1
})


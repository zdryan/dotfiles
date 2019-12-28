return require("packer").startup(function()
	use "wbthomason/packer.nvim"
	
	-- LSP
	use "neovim/nvim-lspconfig"
	use "williamboman/mason.nvim"
	use "williamboman/mason-lspconfig.nvim"
	use "hrsh7th/nvim-cmp"
	use "hrsh7th/cmp-nvim-lsp"
	use "L3MON4D3/LuaSnip"
	use "j-hui/fidget.nvim"
	use "numirias/semshi"

	-- Fuzzy
	use "ibhagwan/fzf-lua"

	-- Dev
	use "folke/neodev.nvim"
	use "nvim-lua/plenary.nvim"

	-- Theme
	use "nvim-lualine/lualine.nvim"
	use {"akinsho/bufferline.nvim", tag = "*", requires = "nvim-tree/nvim-web-devicons"}
	use "sunjon/shade.nvim"

	-- Utility
	use "MattesGroeger/vim-bookmarks"
	use "christoomey/vim-tmux-navigator"
	use "folke/which-key.nvim"

	-- VCS
	use "tpope/vim-fugitive"
	use "lewis6991/gitsigns.nvim"
end)

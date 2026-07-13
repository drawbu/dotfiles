vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

vim.api.nvim_create_autocmd('FileType', {
    desc = 'Enable treesitter highlighting and indentation',
    callback = function(args)
        if not pcall(vim.treesitter.start) then
            return -- no parser for this filetype, keep the defaults
        end
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/nvim-cmp",
        { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local keymap = vim.keymap -- for conciseness
        local opts = { noremap = true, silent = true }

        local on_attach = function(client, bufnr)
            opts.buffer = bufnr

            -- KEYBINDINGS
            opts.desc = "Go to declaration"
            keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

            opts.desc = "Show LSP definitions"
            keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- show lsp definitions

            opts.desc = "Show documentation for what is under cursor"
            keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

            opts.desc = "Show LSP implementations"
            keymap.set("n", "gi", vim.lsp.buf.implementation, opts) -- show lsp implementations

            -- fbardos: disabled, because causes interference with gt (go-to next tab)
            -- opts.desc = "Show LSP type definitions"
            -- keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

            opts.desc = "Show LSP error diagnostics"
            keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts) -- show lsp error diagnostics

            opts.desc = "Show LSP references"
            keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

            opts.desc = "See available code actions"
            keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

            -- Highlighting references.
            -- See: https://sbulav.github.io/til/til-neovim-highlight-references/
            -- for the highlight trigger time see: `vim.opt.updatetime`
            vim.opt.updatetime = 300
            if client.server_capabilities.documentHighlightProvider then
                vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
                vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
                vim.api.nvim_create_autocmd("CursorHold", {
                    callback = vim.lsp.buf.document_highlight,
                    buffer = bufnr,
                    group = "lsp_document_highlight",
                    desc = "Document Highlight",
                })
                vim.api.nvim_create_autocmd("CursorMoved", {
                    callback = vim.lsp.buf.clear_references,
                    buffer = bufnr,
                    group = "lsp_document_highlight",
                    desc = "Clear All the References",
                })
            end
        end

        -- used to enable autocompletion (assign to every lsp server config)
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Change the Diagnostic symbols in the sign column (gutter)
        -- (not in youtube nvim video)
        -- local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        -- for type, icon in pairs(signs) do
        --     local hl = "DiagnosticSign" .. type
        --     vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        -- end

        -- configure html server
        lspconfig["html"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure typescript server with plugin
        lspconfig["ts_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure css server
        lspconfig["cssls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure yaml server
        lspconfig["yamlls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure python server
        lspconfig["pyright"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                python = {
                    analysis = {
			-- 2025-02-22 (fbardos): After some consideration, temporary reenable autoImportCompletions
			-- This will make autoimport easier when inside a python file (accept with <Return>).
			-- After this, isort will sort the imports, but make sure that force_single_line = true is set
			-- in pyproject.toml.
                        autoImportCompletions = true,
                        -- -- Disable auto-complete suggestions in autocomplete (a lot of suggestions)
                        -- autoImportCompletions = false,
                        -- Performance improvements
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = 'openFilesOnly',
                    }
                }
            }
        })

        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = { -- custom settings for lua
                Lua = {
                    -- make the language server recognize "vim" global
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        -- make language server aware of runtime files
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                },
            },
        })
    end,
}

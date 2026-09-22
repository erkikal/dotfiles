# Folding, via nvim-ufo.
{ ... }:

{
  # The `foldlevel`/`foldlevelstart` pinning ufo needs is in `opts` above.
  plugins.nvim-ufo = {
    enable = true;
    settings = {
      provider_selector.__raw = ''
        function(_, ft, _)
          -- Some filetypes fold usefully only via treesitter, others only via
          -- LSP, and ufo takes exactly two providers in priority order.
          local lspWithoutFolding = { 'markdown', 'sh', 'css', 'html', 'python', 'json' }
          if vim.tbl_contains(lspWithoutFolding, ft) then
            return { 'treesitter', 'indent' }
          end
          return { 'lsp', 'indent' }
        end
      '';
      # Fold kinds to close when a buffer opens; `:UfoInspect` lists what the
      # attached LSP offers.
      close_fold_kinds_for_ft.default = [
        "imports"
        "comment"
      ];
      open_fold_hl_timeout = 800;
      # Renders the closed-fold line as its own text plus a trailing line count,
      # truncated to the window width.
      fold_virt_text_handler.__raw = ''
        function(virtText, lnum, endLnum, width, truncate)
          local hlgroup = 'NonText'
          local newVirtText = {}
          local suffix = '   ' .. tostring(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
            else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              local hlGroup = chunk[2]
              table.insert(newVirtText, { chunkText, hlGroup })
              chunkWidth = vim.fn.strdisplaywidth(chunkText)
              if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, { suffix, hlgroup })
          return newVirtText
        end
      '';
    };
  };
}

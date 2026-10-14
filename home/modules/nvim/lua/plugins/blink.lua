-- blink.cmp fuzzy matcher: native (Rust) on the host, Lua inside OpenShell
-- sandboxes.
--
-- By default blink.cmp downloads its native library (libblink_cmp_fuzzy) from
-- GitHub releases at runtime. Inside a sandbox that download is denied by the
-- network policy, and it would fail anyway: blink.cmp derives the release tag
-- with `git describe --tags`, and lazy-lock.json pins an untagged `main`
-- commit. The Lua implementation needs no library, and blink.cmp disables the
-- download when implementation = "lua".
--
-- The host keeps the default (prefer_rust_with_warning) and its already
-- downloaded library.
return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      if vim.env.OPENSHELL_SANDBOX == "1" then
        opts.fuzzy = vim.tbl_deep_extend("force", opts.fuzzy or {}, { implementation = "lua" })
      end
    end,
  },
}

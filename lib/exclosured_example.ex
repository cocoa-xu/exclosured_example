defmodule ExclosuredExample do
  @moduledoc """
  Example library demonstrating Exclosured precompilation.

  Provides a Markdown-to-HTML parser powered by Rust's `pulldown-cmark`
  crate, compiled to WebAssembly and distributed as a precompiled binary.

  Consumers of this library do NOT need the Rust toolchain installed.
  The precompiled `.wasm` and `.js` files are downloaded automatically
  from GitHub Releases during `mix compile`.

  ## Usage in Phoenix LiveView

      defmodule MyAppWeb.EditorLive do
        use Phoenix.LiveView

        def render(assigns) do
          ~H\"\"\"
          <div id="md" phx-hook="Exclosured" data-wasm-module="exclosured_example_markdown"></div>
          \"\"\"
        end
      end

  ## WASM module info

      ExclosuredExample.Markdown.wasm_url()
      #=> "/wasm/exclosured_example_markdown/exclosured_example_markdown_bg.wasm"

      ExclosuredExample.Markdown.wasm_exports()
      #=> [:parse_markdown]
  """
end

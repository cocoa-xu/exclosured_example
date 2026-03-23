defmodule ExclosuredExample.Markdown do
  @moduledoc """
  Inline WASM module that parses Markdown to HTML using the Rust
  `pulldown-cmark` crate.

  The Rust code is compiled to WebAssembly at build time via
  `Exclosured.Inline`. It runs in the browser on every keystroke
  for sub-millisecond rendering.

  ## Exported functions

    * `parse_markdown` - receives a binary buffer containing UTF-8
      Markdown text, parses it with pulldown-cmark (with tables,
      strikethrough, and tasklists enabled), writes HTML back into
      the same buffer, and returns the HTML byte length.

  ## Browser usage

      const wasmName = "exclosured_example_markdown";
      const mod = await import(`/wasm/${wasmName}/${wasmName}.js`);
      const wasm = await mod.default(`/wasm/${wasmName}/${wasmName}_bg.wasm`);

      // Allocate buffer, write markdown, call parse_markdown, read HTML
      const bufSize = Math.max(inputBytes.length * 4, 4096);
      const ptr = wasm.alloc(bufSize);
      const mem = new Uint8Array(wasm.memory.buffer, ptr, bufSize);
      mem.fill(0);
      mem.set(inputBytes);
      const htmlLen = wasm.parse_markdown(ptr, bufSize);
      const html = new TextDecoder().decode(new Uint8Array(wasm.memory.buffer, ptr, htmlLen));
      wasm.dealloc(ptr, bufSize);
  """

  use Exclosured.Inline

  defwasm :parse_markdown, args: [input: :binary], deps: [{"pulldown-cmark", "0.12"}] do
    ~RUST"""
    use pulldown_cmark::{Parser, Options, html::push_html};

    // Trim trailing null bytes to find actual input length
    let end = input.iter().rposition(|&b| b != 0).map_or(0, |i| i + 1);
    let md = match core::str::from_utf8(&input[..end]) {
        Ok(s) => s,
        Err(_) => return -1,
    };

    // Enable common markdown extensions
    let mut options = Options::empty();
    options.insert(Options::ENABLE_TABLES);
    options.insert(Options::ENABLE_STRIKETHROUGH);
    options.insert(Options::ENABLE_TASKLISTS);
    let parser = Parser::new_ext(md, options);

    let mut html_output = String::new();
    push_html(&mut html_output, parser);

    let bytes = html_output.as_bytes();
    let n = bytes.len().min(input.len());
    input[..n].copy_from_slice(&bytes[..n]);
    return n as i32;
    """
  end
end

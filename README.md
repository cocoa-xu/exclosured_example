# ExclosuredExample

An example library demonstrating how to distribute precompiled WASM
modules with [Exclosured](https://github.com/cocoa-xu/exclosured) and
[ExclosuredPrecompiled](https://github.com/cocoa-xu/exclosured_precompiled).

This library provides a Markdown-to-HTML parser powered by Rust's
[pulldown-cmark](https://crates.io/crates/pulldown-cmark) crate,
compiled to WebAssembly and distributed as a precompiled binary.

**Consumers do not need Rust installed.** The precompiled `.wasm` and
`.js` files are downloaded automatically from GitHub Releases.

## Installation

```elixir
def deps do
  [{:exclosured_example, "~> 0.1.0"}]
end
```

No Rust, `cargo`, or `wasm-bindgen` needed. The WASM files are
downloaded during `mix compile`.

## Usage

The library provides `ExclosuredExample.Markdown`, a WASM module that
parses Markdown to HTML in the browser.

### In Phoenix LiveView

```elixir
# In your LiveView template:
<div id="md"
  phx-hook="Exclosured"
  data-wasm-module="exclosured_example_markdown">
</div>
```

### Direct WASM loading (no LiveView)

```javascript
const name = "exclosured_example_markdown";
const mod = await import(`/wasm/${name}/${name}.js`);
const wasm = await mod.default(`/wasm/${name}/${name}_bg.wasm`);

// Parse markdown
const input = new TextEncoder().encode("# Hello **world**");
const bufSize = Math.max(input.length * 4, 4096);
const ptr = wasm.alloc(bufSize);
const mem = new Uint8Array(wasm.memory.buffer, ptr, bufSize);
mem.fill(0);
mem.set(input);

const htmlLen = wasm.parse_markdown(ptr, bufSize);
const html = new TextDecoder().decode(
  new Uint8Array(wasm.memory.buffer, ptr, htmlLen)
);
wasm.dealloc(ptr, bufSize);

console.log(html); // <h1>Hello <strong>world</strong></h1>
```

## How it works

This library uses three packages:

1. **[exclosured](https://hex.pm/packages/exclosured)** - Compiles Rust
   to WASM via `defwasm` inline macro
2. **[exclosured_precompiled](https://hex.pm/packages/exclosured_precompiled)** -
   Downloads precompiled WASM from GitHub Releases so consumers skip the
   Rust toolchain
3. **[exclosured (npm)](https://www.npmjs.com/package/exclosured)** -
   LiveView hook for loading and communicating with WASM modules

### For library authors

This repository serves as a template. The key files:

| File | Purpose |
|------|---------|
| `lib/exclosured_example/markdown.ex` | `defwasm` with pulldown-cmark |
| `lib/exclosured_example/precompiled.ex` | `use ExclosuredPrecompiled` config |
| `.github/workflows/release.yml` | CI: build, package, upload, publish |
| `checksum-*.exs` | SHA-256 checksums (shipped with Hex package) |

### Release workflow

1. Tag a release: `git tag v0.1.0 && git push --tags`
2. GitHub Actions builds the WASM, packages it, uploads to the Release
3. Checksums are generated and the package is published to Hex

See the [Precompilation Guide](https://hexdocs.pm/exclosured_precompiled/precompilation_guide.html)
for a detailed walkthrough.

## Building from source

If you want to compile the WASM yourself instead of using precompiled:

```sh
# Requires Rust toolchain
rustup target add wasm32-unknown-unknown
cargo install wasm-bindgen-cli

# Force build from source
EXCLOSURED_PRECOMPILED_FORCE_BUILD_ALL=1 mix compile
```

## License

MIT

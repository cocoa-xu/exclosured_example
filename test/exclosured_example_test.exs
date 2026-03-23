defmodule ExclosuredExampleTest do
  use ExUnit.Case

  test "Markdown module exposes wasm_exports" do
    assert :parse_markdown in ExclosuredExample.Markdown.wasm_exports()
  end

  test "Markdown module exposes wasm_url" do
    assert ExclosuredExample.Markdown.wasm_url() =~
             "/wasm/exclosured_example_markdown/exclosured_example_markdown_bg.wasm"
  end

  test "Markdown module exposes wasm_module_name" do
    assert ExclosuredExample.Markdown.wasm_module_name() == "exclosured_example_markdown"
  end

  test "compiled WASM file exists" do
    assert File.exists?(ExclosuredExample.Markdown.wasm_path())
  end

  test "compiled WASM has valid magic number" do
    {:ok, bytes} = File.read(ExclosuredExample.Markdown.wasm_path())
    assert <<0x00, 0x61, 0x73, 0x6D, _rest::binary>> = bytes
  end
end

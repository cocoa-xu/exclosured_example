defmodule ExclosuredExample.Precompiled do
  @moduledoc """
  Precompiled WASM distribution for ExclosuredExample.

  When this module is compiled, it checks if the WASM files are already
  present. If not, it downloads them from the GitHub Release and verifies
  the SHA-256 checksum.

  Library consumers do not need the Rust toolchain installed.
  """

  use ExclosuredPrecompiled,
    otp_app: :exclosured_example,
    base_url:
      "https://github.com/cocoa-xu/exclosured_example/releases/download/v#{Mix.Project.config()[:version]}",
    version: Mix.Project.config()[:version],
    modules: [:exclosured_example_markdown]
end

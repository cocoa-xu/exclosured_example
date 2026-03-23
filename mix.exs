defmodule ExclosuredExample.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :exclosured_example,
      version: @version,
      elixir: "~> 1.15",
      compilers: [:exclosured] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:exclosured, "~> 0.1"},
      {:exclosured_precompiled, "~> 0.1", runtime: false}
    ]
  end

  defp description do
    "Example library demonstrating Exclosured precompilation. " <>
      "Provides a Markdown-to-HTML parser powered by Rust's pulldown-cmark, " <>
      "compiled to WebAssembly and distributed as precompiled binaries."
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/cocoa-xu/exclosured_example"},
      files: ~w(lib mix.exs README.md LICENSE CHANGELOG.md checksum-*.exs)
    ]
  end
end

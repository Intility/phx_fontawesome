defmodule PhxFontawesome.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://gitlab.intility.com/soc/phx_fontawesome"

  def project do
    [
      app: :phx_fontawesome,
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: [
        maintainers: ["Rolf Håvard Blindheim <rolf.havard.blindheim@intility.no>"],
        links: %{Gitlab: @source_url}
      ],
      docs: [
        main: "readme",
        source_ref: "v#{@version}",
        extras: [
          "README.md"
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.28.4", only: [:dev, :test], runtime: false},
      {:phoenix, "~> 1.6"},
      {:phoenix_live_view, "~> 0.17"}
    ]
  end
end

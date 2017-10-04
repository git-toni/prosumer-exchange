defmodule Power.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
     {:distillery, "~> 1.4", runtime: false},
     {:edeliver, ">= 0.8.0", warn_missing: false}
    ]
  end
end

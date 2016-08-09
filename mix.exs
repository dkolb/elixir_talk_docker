defmodule HelloWorld.Mixfile do
  use Mix.Project

  @non_release_envs [:test, :dev]

  def project do
    [
     app: :hello_world,
     version: version,
     elixir: "~> 1.3",
     build_embedded: !Enum.member?(@non_release_envs, Mix.env),
     start_permanent: !Enum.member?(@non_release_envs, Mix.env),
     deps: deps
   ]
  end

  def application do
    [
      applications: [:cowboy, :plug, :logger],
      mod: {HelloWorld, []}
    ]
  end

  defp deps do
    [
     {:cowboy, "~> 1.0"},
     {:plug, "~> 1.1"},
     {:exrm, "~> 1.0"}
    ]
  end

  defp version do
    case File.exists?("version.txt") do
      true -> get_version
      false -> "PRE-BUILD"
    end
  end

  defp get_version do
    case File.read "version.txt" do
      {:ok, version} -> String.strip(version)
      {_, _} -> "NO_VERSION_FILE"
    end
  end
end

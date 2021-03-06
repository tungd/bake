defmodule Bake.Cli.Global do
  @menu "global"
  @switches []

  use Bake.Cli.Menu
  require Logger

  def menu do
    """
      set variable value  - Set a global variable
      get variable        - Show a global variable
      clear variable      - Clear a global variable
    """
  end

  def main(args) do
    {_opts, cmd, _} = OptionParser.parse(args, switches: @switches)
    case cmd do
      ["set" | [variable | [value | _]]] -> set(variable, value)
      ["get" | [variable | _]] -> get(variable)
      ["clear" | [variable | _]] -> clear(variable)
      _ -> invalid_cmd(cmd)
    end
  end

  def set(variable, value) do
    Bake.Shell.info "=> Set global variable #{variable} to #{value}"
    Bake.Config.Global.update([{String.to_atom(variable), value}])
  end

  def get(variable) do
    case Bake.Config.Global.read[String.to_atom(variable)] do
      nil -> Bake.Shell.info "=> Global variable #{variable} is not set"
      value -> Bake.Shell.info "=> Global variable #{variable}: #{value}"
    end
  end

  def clear(variable) do
    case get(variable) do
      nil -> Bake.Shell.info "=> Global variable #{variable} is not set"
      _ ->
        Bake.Config.Global.read
        |> Keyword.delete(String.to_atom(variable))
        |> Bake.Config.Global.write
    end
  end

end

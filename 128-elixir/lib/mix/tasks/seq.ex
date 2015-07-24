defmodule Mix.Tasks.Seq do
  use Mix.Task

  def run(_) do
    Euler128.main(2000)
  end
end

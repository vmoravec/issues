defmodule Issues.Cli do
  @default_count 4

  def main argv do
    argv |> parse_args |> process
  end

  def parse_args argv do
    parser_result = OptionParser.parse(
      argv,
      switches: [ help: :boolean ],
      aliases: []
    )

    case parser_result do
      {[help: true], _, _ }          -> :help
      {_, [project, count], _} -> {project, String.to_integer(count)}
      {_,[project ], _}        -> {project, @default_count}
      _                              -> :help
    end
  end

  def process :help do
    IO.puts """
      usage: <project> [count | #{@default_count}]
    """
    System.halt(0)
  end

  def process({project, _count}) do
    result = Issues.Github.fetch(project)
    IO.puts("Returning result:")
    IO.puts(inspect result)

    case result do
      { :ok, _ } -> System.halt(0)
      { :error, _ } -> System.halt(1)
    end
  end

end

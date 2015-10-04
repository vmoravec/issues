defmodule Issues.Github do
  @user_agent [ {"User-agent", "elixir vmoravec@suse.com"} ]
  @user "vmoravec"

  def fetch project do
    url(project) |> HTTPoison.get(@user_agent) |> handle_response
  end

  defp handle_response { :ok, %HTTPoison.Response{status_code: 200, body: body}} do
    { :ok, :jsx.decode(body) }
  end

  defp handle_response { :ok , %HTTPoison.Response{body: body}} do
    { :error, :jsx.decode(body) }
  end

  defp url project do
    result = "https://api.github.com/repos/#{@user}/#{project}/issues"
    IO.puts("Going to fetch from #{result}")
    result
  end
end

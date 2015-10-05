defmodule Issues.Basic do
  def greet do
    receive do
      { sender, msg } -> send(sender, { :ok, "Hello, #{msg}"})
      greet
    end
  end
end

defmodule Issues.Receiver do
  require Logger

  def say do
    pid = spawn(Issues.Basic, :greet, [])
    send(pid, { self, "good morning" })
    receive do
      {:ok, message} -> Logger.info((message)); Logger.info(inspect pid)
    end
  end
end

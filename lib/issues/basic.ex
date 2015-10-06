defmodule Issues.Basic do
  def greet whatever do
    receive do
      { sender, msg } -> send(sender, { :ok, "Hello, #{msg}\n#{whatever}"})
      greet whatever
    end
  end
end

defmodule Issues.Receiver do
  require Logger

  def say something do
    pid = spawn(Issues.Basic, :greet, [something])
    send(pid, { self, "good morning" })
    receive do
      {:ok, message} -> Logger.info((message)); Logger.info(inspect pid)
    end
  end
end

defmodule Link do
  import :timer, only: [ sleep: 1 ]

  def sad do
    IO.puts "sleeping"
    sleep 500
    receive do
      { :ok, guest } -> send(guest, "THIS IS FROM SAD, #{inspect self}")
    end
    exit(:boom)
  end

  def run do
    pid = spawn(Link, :sad, [])
    send(pid, { :ok, self })
    receive do
      msg -> IO.puts "Arrived: #{msg}"
    after 1000 -> IO.puts "after 100 nothing happend"
    end
  end

end

defmodule LinkT do
  import :timer, only: [ sleep: 1 ]

  def sad do
    sleep 100
  end

  def run do
    Process.flag(:trap_exit, true)
    spawn_link(LinkT, :sad, [])
    receive do
      msg -> IO.puts "MESSAGE: #{inspect msg}"
    after 200 -> IO.puts "Nothing happend"
    end
  end
end

LinkT.run

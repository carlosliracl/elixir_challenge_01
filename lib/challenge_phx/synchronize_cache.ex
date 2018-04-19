defmodule ChallengePhx.SynchronizeCache do
  use GenServer
  
  def start_link() do
    GenServer.start_link(__MODULE__, [], name: Foo)
  end
end
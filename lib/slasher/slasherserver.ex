defmodule Slasher.SlasherServer do
  use GenServer

  alias Slasher.SlasherCode

  # Client API
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def stop(pid) do
    GenServer.cast(pid, :stop)
  end

  def shorten(pid, long_url) do
    GenServer.call(pid, {:shorten, long_url})
  end

  def get(pid, short_url) do
    GenServer.call(pid, {:get, short_url})
  end

  # GenServer callbacks
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  def handle_call({:shorten, long_url}, _from, state) do
    hashId = SlasherCode.shorten(long_url)
    {:reply, hashId, Map.put(state, hashId, long_url)}
  end

  def handle_call({:get, short_url}, _from, state) do
    {:reply, Map.get(state, short_url), state}
  end
end

defmodule TicTacToe.Session do
  use GenServer
  import GenServer, only: [call: 2]

  alias TicTacToe.Game

  # --- Startup --- #

  def child_spec(session) do
    %{
      id:      {__MODULE__, session},
      start:   {__MODULE__, :start_link, [session]},
      restart: :temporary
    }
  end

  def start_link(session) do
    GenServer.start_link(__MODULE__, Game.new, name: via(session))
  end

  # --- API --- #

  def new_game(session) do
    DynamicSupervisor.start_child(
      TicTacToe.Session.DynamicSupervisor,
      {__MODULE__, session}
    )
  end

  def alive?(session) do
    with [{pid, _}] <- Registry.lookup(TicTacToe.Session.Registry, session),
         true       <- Process.alive?(pid),
         do:   :ok,
         else: (_ -> {:error, :unknown_session})
  end

  def game(session) do
    call(via(session), :game)
  end

  def play(session, move) do
    call(via(session), {:play, move})
  end

  defp via(session) do
    {
      :via,
      Registry,
      {TicTacToe.Session.Registry, session}
    }
  end

  # --- Server --- #

  def init(game) do
    {:ok, game}
  end

  def handle_call(:game, _from, game) do
    {:reply, game, game}
  end

  def handle_call({:play, move}, _from, game) do
    game = game |> Game.play(move)
    case game.state do
      :finished ->
        {:stop, :normal, game, nil}
      _ ->
        {:reply, game, game}
    end
  end
end

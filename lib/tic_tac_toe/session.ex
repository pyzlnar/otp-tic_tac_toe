defmodule TicTacToe.Session do
  use GenServer
  import GenServer, only: [call: 2]

  alias TicTacToe.Game

  # --- API --- #
  def start_link(_) do
    GenServer.start_link(__MODULE__, Game.new)
  end

  def move(session, move) do
    call(session, {:move, move})
  end

  # --- Server --- #

  def init(game) do
    {:ok, game}
  end

  def handle_call({:move, move}, _from, game) do
    game = game |> Game.play(move)
    case game.state do
      :finished ->
        {:stop, :normal, game, nil}
      _ ->
        {:reply, game.board, game}
    end
  end
end

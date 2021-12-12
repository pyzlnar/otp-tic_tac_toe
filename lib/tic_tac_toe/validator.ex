defmodule TicTacToe.Validator do
  alias TicTacToe.Game

  def valid_move?(%Game{state: :finished}, _) do
    {:error, [state: "is no longer in progress"]}
  end

  def valid_move?(game, {x, y} = move) when x in 0..2 and y in 0..2 do
    case game.board[move] do
      nil ->
        :ok
      _ ->
        {:error, [move: "#{inspect(move)} already played"]}
    end
  end

  def valid_move?(_, move) do
    {
      :error,
      [move: "has to match {x,y} when x in 0..2 and y in 0..2. Got: #{inspect(move)}"]
    }
  end
end

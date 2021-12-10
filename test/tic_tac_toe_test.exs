defmodule TicTacToeTest do
  use ExUnit.Case, async: true

  alias TicTacToe.Game

  describe "happy path games" do
    test "game with winner" do
      game = TicTacToe.new_game

      result = game |> TicTacToe.play({0,0})
      assert {:ok, %Game{}} = result

      game |> TicTacToe.play({1,1})
      game |> TicTacToe.play({0,1})
      game |> TicTacToe.play({2,1})

      result = game |> TicTacToe.play({0,2})
      assert {:finished, %Game{} = final} = result

      assert final.state == :finished
      assert is_integer(final.winner)
    end
  end
end

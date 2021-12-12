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

      assert final.state  == :finished
      assert final.winner == 1
    end

    test "game with stalemate" do
      game = TicTacToe.new_game

      result = game |> TicTacToe.play({0,0})
      assert {:ok, %Game{}} = result

      game |> TicTacToe.play({1,1})
      game |> TicTacToe.play({0,1})
      game |> TicTacToe.play({0,2})
      game |> TicTacToe.play({2,0})
      game |> TicTacToe.play({1,0})
      game |> TicTacToe.play({1,2})
      game |> TicTacToe.play({2,1})

      result = game |> TicTacToe.play({2,2})
      assert {:finished, %Game{} = final} = result

      assert final.state == :finished
      assert is_nil(final.winner)
    end
  end

  describe "edgecases and errors" do
    test "returns error if trying to play on non-existing session" do
      assert {:error, :unknown_session} = TicTacToe.play(:dead, {0,0})
    end

    test "returns error if trying to start an already existing game" do
      id = make_ref()
      TicTacToe.new_game(id)

      assert {:error, {:already_started, _}} = TicTacToe.new_game(id)
    end
  end
end

defmodule TicTacToe.ValidatorTest do
  use ExUnit.Case
  alias TicTacToe.{Game, Validator}

  describe "valid_move?/2" do
    test "returns :ok if it receives a valid move" do
      game   = Game.new
      result = Validator.valid_move?(game, {0,0})

      assert :ok = result
    end

    test "returns :error if game is already finished" do
      game   = %{Game.new|state: :finished}
      result = Validator.valid_move?(game, {0,0})

      assert {:error, [state: msg]} = result
      assert msg =~ ~r/is no longer in progress/
    end

    test "returns :error if move has been played previously" do
      game   = %{Game.new|board: %{{0,0} => 1}}
      result = Validator.valid_move?(game, {0,0})

      assert {:error, [move: msg]} = result
      assert msg =~ ~r/already played/
    end

    test "returns :error if move has an invalid format" do
      game = Game.new

      result = Validator.valid_move?(game, :atom)
      assert {:error, [move: _]} = result

      result = Validator.valid_move?(game, {:a, :b})
      assert {:error, [move: _]} = result

      result = Validator.valid_move?(game, {-1, 2})
      assert {:error, [move: msg]} = result

      assert msg =~ ~r/has to match {x,y} when x in 0..2 and y in 0..2/
    end
  end
end

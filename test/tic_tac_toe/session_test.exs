defmodule TicTacToe.SessionTest do
  use ExUnit.Case, async: true

  alias TicTacToe.Session

  describe "new_game/1" do
    test "starts a new server" do
      assert {:ok, pid} = Session.new_game(:test_game)
      assert Process.alive?(pid)

      Process.exit(pid, :kill)
    end
  end

  describe "play/2" do
    test "moves a game to the next state" do
      ref = make_ref()
      Session.new_game(ref)

      move   = {0,0}
      result = Session.play(ref, move)

      assert result.state       == :progress
      assert result.board[move] == 1
      assert result.player      == 2
      assert is_nil(result.winner)
    end
  end
end

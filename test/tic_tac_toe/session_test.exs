defmodule TicTacToe.SessionTest do
  use ExUnit.Case, async: true

  alias TicTacToe.Session

  describe "new_game/1" do
    test "starts a new server" do
      assert {:ok, pid} = Session.new_game(:test_game)
      assert Process.alive?(pid)

      Process.exit(pid, :kill)
    end

    test "returns an error if the process already started" do
      {:ok, pid} = Session.new_game(:test_game)

      assert {:error, {:already_started, npid}} = Session.new_game(:test_game)
      assert pid == npid

      Process.exit(pid, :kill)
    end
  end

  describe "alive?/1" do
    test "returns :ok if a session is still alive" do
      ref = make_ref()
      Session.new_game(ref)
      assert :ok = Session.alive?(ref)
    end

    test "returns :error if a session process is no longer alive" do
      assert {:error, :unknown_session} = Session.alive?(:unknown)

      {:ok, pid} = Session.new_game(:will_kill_process)
      Process.exit(pid, :kill)
      assert {:error, :unknown_session} = Session.alive?(:will_kill_process)
    end
  end

  describe "game/1" do
    test "returns the game of an existing session" do
      ref = make_ref()
      Session.new_game(ref)

      assert %TicTacToe.Game{} = Session.game(ref)
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

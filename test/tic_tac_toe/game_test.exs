defmodule TicTacToe.GameTest do
  use ExUnit.Case, async: true
  import TicTacToe.Game

  setup_all ~W[
    setup_new_game
    setup_finished_board
    setup_stalemate_board
    setup_almost_done_game
    setup_finished_game
  ]a

  describe "new/0" do
    test "returns a brand new game", %{new: game} do
      assert %TicTacToe.Game{} = game
      assert game.state  == :initial
      assert game.player == 1
      assert game.winner == nil

      assert 9 == Enum.count(game.board)
      assert 9 == Enum.count(game.board, fn {_k, v} -> v == nil end)
    end
  end

  describe "play/1" do
    test "fully moves the game to the next state", %{new: new_game} do
      move = {0,0}
      game = new_game |> play(move)

      assert %TicTacToe.Game{} = game
      assert game.state  == :progress
      assert game.player == 2
      assert game.winner == nil

      assert 9 == Enum.count(game.board)
      assert 8 == Enum.count(game.board, fn {_k, v} -> v == nil end)
      assert game.board[move] == 1
    end

    test "finishes a game if the move ends it", %{almost_done: almost_done_game} do
      move = {2,0}
      game = almost_done_game |> play(move)

      assert %TicTacToe.Game{} = game
      assert game.state  == :finished
      assert game.player == 1
      assert game.winner == 1
    end
  end

  describe "update_board/2" do
    test "updates the board with the current player", %{new: game} do
      move = {0,0}
      game = game |> update_board(move)
      assert game.board[move] == game.player

      game = %{game|player: 2}
      move = {0,1}
      game = game |> update_board(move)
      assert game.board[move] == game.player
    end
  end

  describe "update_state/1" do
    test "updates fields when state is :initial",  %{new: game} do
      game = game |> update_state
      assert game.state  == :progress
      assert game.player == 2
    end

    test "updates fields when mid game move is done", %{almost_done: game} do
      game = game |> update_state
      assert game.state  == :progress
      assert game.player == 2
      assert is_nil(game.winner)
    end

    test "updates fields when board has a winner", %{finished_board: game} do
      game = game |> update_state
      assert game.state  == :finished
      assert game.player == 1
      assert game.winner == 1
    end

    test "updates fields when board has no moves", %{stalemate_board: game} do
      game = game |> update_state
      assert game.state  == :finished
      assert game.player == 1
      assert is_nil(game.winner)
    end
  end

  describe "update_next_player/1" do
    test "switches to the next player", %{new: game} do
      game = %{game|player: 1}
      game = game |> update_next_player
      assert game.player == 2

      game = %{game|player: 2}
      game = game |> update_next_player
      assert game.player == 1
    end
  end

  describe "board_has_winner?/1" do
    test "it returns true if the board is finished", %{finished_game: game} do
      assert board_has_winner?(game)
    end

    test "it returns false if the board is finished", %{new: game} do
      refute board_has_winner?(game)
    end
  end

  describe "board_full?/1" do
    test "returns true if the board has no available moves", %{stalemate_board: game} do
      assert board_full?(game)
    end

    test "returns false if the board still has moves",
    %{new: new_game, almost_done: almost_done_game}
    do
      refute board_full?(new_game)
      refute board_full?(almost_done_game)
    end
  end

  # --- Helpers --- #

  def setup_new_game(context) do
    put_in(context[:new], new())
  end

  def setup_finished_board(context) do
    board = %{
      {0,0} => 1, {0,1} => 2,   {0,2} => nil,
      {1,0} => 1, {1,1} => nil, {1,2} => 2,
      {2,0} => 1, {2,1} => nil, {2,2} => nil
    }
    finished = %{context[:new]|board: board, state: :progress}

    put_in(context[:finished_board], finished)
  end

  def setup_finished_game(context) do
    finished = %{context[:finished_board]|state: :finished}
    put_in(context[:finished_game], finished)
  end

  def setup_almost_done_game(context) do
    board = %{
      {0,0} => 1,   {0,1} => 2,   {0,2} => nil,
      {1,0} => 1,   {1,1} => nil, {1,2} => 2,
      {2,0} => nil, {2,1} => nil, {2,2} => nil
    }
    almost_done = %{context[:new]|board: board, state: :progress}
    put_in(context[:almost_done], almost_done)
  end

  def setup_stalemate_board(context) do
    board = %{
      {0,0} => 1, {0,1} => 2, {0,2} => 1,
      {1,0} => 1, {1,1} => 2, {1,2} => 2,
      {2,0} => 2, {2,1} => 1, {2,2} => 2
    }
    stalemate_board = %{context[:new]|board: board, state: :progress}
    put_in(context[:stalemate_board], stalemate_board)
  end
end

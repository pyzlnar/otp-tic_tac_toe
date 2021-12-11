defmodule TicTacToe.Game do
  defstruct ~W[board state player winner]a

  @wins [
    [{0,0},{0,1},{0,2}],
    [{1,0},{1,1},{1,2}],
    [{2,0},{2,1},{2,2}],

    [{0,0},{1,0},{2,0}],
    [{0,1},{1,1},{2,1}],
    [{0,2},{1,2},{2,2}],

    [{0,0},{1,1},{2,2}],
    [{2,0},{1,1},{0,2}]
  ]

  def new do
    %__MODULE__{
      board: %{
        {0,0} => nil, {0,1} => nil, {0,2} => nil,
        {1,0} => nil, {1,1} => nil, {1,2} => nil,
        {2,0} => nil, {2,1} => nil, {2,2} => nil
      },
      state:  :initial,
      player: 1,
      winner: nil
    }
  end

  def play(game, {_,_} = move) do
    game
    |> update_board(move)
    |> update_state
  end

  def update_board(game, {_,_} = move) do
    update_in(game.board[move], fn _ -> game.player end)
  end

  def update_state(%__MODULE__{} = game) do
    cond do
      game.state == :initial ->
        %{game|state: :progress} |> update_next_player
      board_has_winner?(game) ->
        %{game|state: :finished, winner: game.player}
      board_full?(game) ->
        %{game|state: :finished}
      true ->
        game |> update_next_player
    end
  end

  def board_has_winner?(%__MODULE__{board: board}) do
    @wins
    |> Enum.any?(fn line ->
      line
      |> Enum.frequencies_by(&board[&1])
      |> Enum.any?(fn
        {nil, _} -> false
        {_, 3}   -> true
        {_, _}   -> false
      end)
    end)
  end

  def board_full?(%__MODULE__{board: board}) do
    Enum.all?(board, fn {_coord, val} -> val end)
  end

  def update_next_player(%__MODULE__{player: 1} = game), do: %{game|player: 2}
  def update_next_player(%__MODULE__{player: 2} = game), do: %{game|player: 1}


  def board_to_string(%__MODULE__{board: board}) do
    for x <- 0..2, y <- 0..2, into: "" do
      separator = if y == 2, do: "\n", else: "|"
      move =
        board[{x,y}]
        |> move_to_string

      move <> separator
    end
  end

  defp move_to_string(1), do: "0"
  defp move_to_string(2), do: "X"
  defp move_to_string(_), do: "_"
end

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
    |> update_winner
    |> update_next_player
  end

  def update_board(game, {_,_} = move) do
    update_in(game.board[move], fn _ -> game.player end)
  end

  def update_state(%__MODULE__{state: :initial} = game), do: %{game|state: :progress}
  def update_state(%__MODULE__{state: :progress} = game) do
    if board_finished?(game),
      do:   %{game|state: :finished},
      else: game
  end

  def update_winner(%__MODULE__{state: :finished} = game), do: %{game|winner: game.player}
  def update_winner(%__MODULE__{} = game),                 do: game

  def update_next_player(%__MODULE__{player: 1, state: :progress} = game), do: %{game|player: 2}
  def update_next_player(%__MODULE__{player: 2, state: :progress} = game), do: %{game|player: 1}
  def update_next_player(%__MODULE__{} = game),                            do: game

  def board_finished?(%__MODULE__{board: board}) do
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

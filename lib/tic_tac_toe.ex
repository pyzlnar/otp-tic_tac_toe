defmodule TicTacToe do
  alias TicTacToe.{Game, Session, Validator}

  def new_game(session \\ make_ref()) do
    with {:ok, _} <- Session.new_game(session),
         do: session
  end

  def get_game(session) do
    with :ok  <- Session.alive?(session),
         game <- Session.game(session),
         do: {:ok, game}
  end

  def play(session, move) do
    with :ok            <- Session.alive?(session),
         game           <- Session.game(session),
         :ok            <- Validator.valid_move?(game, move),
         %Game{} = game <- Session.play(session, move),
         response       <- game_to_response(game),
         do: response
  end

  defp game_to_response(%Game{state: :finished} = game), do: {:finished, game}
  defp game_to_response(%Game{} = game),                 do: {:ok, game}
end

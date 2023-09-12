defmodule MathChallenger.MemoryTasks do

  import Matchallenger.MemoryUtils

  defp selected_letters(map_alphabet)  do
    vocales = get_vowels(map_alphabet, [])
    consonants = get_consonants(map_alphabet, [])
    Enum.concat(vocales, consonants)
  end

  def init_game do
    sel_letters = selected_letters(alphabet_map())
    solved = load_board(sel_letters)
    IO.puts("¡Bienvenido!")
    player ="isabel"  #   git
    game(board(), solved, player, 3, 0, 0)

  end

  defp game(board_on, solved_board, player, lifes, acc_v, acc_c) when lifes > 0 and acc_v < 3 and acc_c < 3  do
    #Información del juego
    IO.puts("Player: #{player}")
    IO.puts("Lives: #{lifes}")
    IO.puts("Vowels:  #{acc_v}")
    IO.puts("Consonants:  #{acc_c}")
    IO.puts(board_on)

    #Pedido por teclado
    ing_pair = IO.gets("Input a pair x,y: ")
               |> String.trim
               |> String.split(",")
               |> Enum.map(&String.to_integer/1)
               |> List.to_tuple


    #Construyendo los pares {{letra1, posicion1},{letra2,posicion2}} que corresponde a la coordenada ingresada.
    {pair1, pair2} = raw_positions(Map.keys(solved_board),Map.values(solved_board))
                     |> Enum.filter(fn {k,_v} -> k ==  elem(ing_pair, 0) or k == elem(ing_pair, 1) end) |> List.to_tuple

    #Mostrar la selección en el tablero utilizando lo anterior
    IO.puts(reveal_cards(board_on, pair1, pair2))

    case {String.downcase(elem(pair1, 1)), String.downcase(elem(pair2, 1))} do
      {match1, match2} when match1 == match2 ->
        updated_board = reveal_cards(board_on, pair1, pair2)
        {vowel, consonant} = compare_pair(pair1)
        game(updated_board, solved_board, player, lifes, acc_v + (vowel == :correct), acc_c + (consonant == :correct))

      _ ->
        IO.puts("Incorrecto, intenta de nuevo")
        game(board_on, solved_board, player, lifes - 1, acc_v, acc_c)
    end

end

  defp game(_, _, _, lifes, _acc_v, _acc_c) when lifes == 0, do: {:gameover, :finished}

  defp game(_, _, _, _, _acc_v, _acc_c), do: {:winner}

  defp reveal_cards(board_on, pair1, pair2) do
    p1 = to_string(elem(pair1, 0))
    p2 = to_string(elem(pair2, 0))
    String.replace(board_on, "-"<>p1<>"-", elem(pair1, 1)) |> String.replace("-"<>p2<>"-", elem(pair2,1))

  end

end
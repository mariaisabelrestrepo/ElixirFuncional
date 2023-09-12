defmodule Matchallenger.MemoryUtils do
  #Carga del tablero
  def board() do
    """
    [ 1 ]  [ 2  ]  [ 3  ]  [ 4  ]
    [ 5 ]  [ 6  ]  [ 7  ]  [ 8  ]
    [ 9 ]  [ 10 ]  [ 11 ]  [ 12 ]
    """
  end

  #Mapa con todas las letras del alfabeto (mayús y minus) y clasificarlas en vocales y consonantes no encontradas.
  def alphabet_map() do
    vocales = ["a", "e", "i", "o", "u"]
    alphabet = for letter <- String.graphemes("abcdefghijklmnopqrstuvwxyz") do
      case letter in vocales do
        true -> {String.to_atom(letter), {String.upcase(letter), letter, :vocal, :notfound}}
        false -> {String.to_atom(letter), {String.upcase(letter), letter, :consonante, :notfound}}
      end
    end

    Map.new(alphabet) #%{a: {"A","a",:vocal, :notfound}, b:{"B", "b", :consonante, :notfound},...}
  end

  #Obtener las vocales a jugar
  def get_vowels(alpha_map, l_vowels) when length(l_vowels) < 3 do
    claves_vocales = Enum.filter(alpha_map, fn{_k,v} -> elem(v,2) == :vocal end) |> Enum.into(%{}) |> Map.keys
    clave_v = Enum.random(claves_vocales)
    valor_v = Map.get(alpha_map, clave_v)
    par = {elem(valor_v, 0), elem(valor_v,1), elem(valor_v,2), elem(valor_v,3)}
    l_vocales = unless Enum.member?(l_vowels, par), do: [par | l_vowels], else: l_vowels
    get_vowels(alpha_map, l_vocales)
  end

  def get_vowels(_, l_vowels), do: l_vowels


  #Obtener las consonantes a jugar
  def get_consonants(alpha_map, l_conson) when length(l_conson) < 3 do
    claves_consonantes= Enum.filter(alpha_map, fn{_k,v} -> elem(v,2) == :consonante end) |> Enum.into(%{}) |> Map.keys
    clave_c = Enum.random(claves_consonantes)
    valor_c = Map.get(alpha_map, clave_c)
    par = {elem(valor_c, 0), elem(valor_c,1), elem(valor_c, 2), elem(valor_c, 3)}
    l_consonantes = unless Enum.member?(l_conson, par), do: [par | l_conson], else: l_conson
    get_consonants(alpha_map, l_consonantes)
  end

  def get_consonants(_, l_conson), do: l_conson

  #Creación del tablero para el juego -  Por completar
  def load_board(sel_letters) do
    #Creación de un rango de posiciones, que se vuelve lista y luego se 'agita' para que queden en un orden cualquiera,
    #se agrupa en pares (Lista de listas) y luego se vuelve una lista de tuplas


    pos_pares = 1..12 |> Enum.to_list |> Enum.shuffle() |> Enum.chunk_every(2) |> Enum.map(fn [a, b] -> {a, b} end)

    Map.new(Enum.zip(pos_pares,sel_letters))

  end
  #Resultado esperado (ejemplo que varía por la aleatoriedad): 1..12 > [1,2,3,4...,12] > [5,1,6,7,...,9,8] > [[5, 1], [6, 7], ..., [9, 8]] > [{5, 1}, {6, 7}, ..., {9, 8}]

  #Por completar: Asociar el contenido de pos_pares a sel_letters de modo que a cada par de posiciones en pos_pares
  #le corresponda un par de vocales/consonantes de sel letters por medio de un mapa.
  #Resultado esperado
  #   %{
  #  {1, 6} => {"S", "s", :consonante, :notfound},
  #  {4, 2} => {"O", "o", :vocal, :notfound},
  #  {5, 3} => {"H", "h", :consonante, :notfound},
  #  {9, 12} => {"E", "e", :vocal, :notfound},
  #  {10, 7} => {"U", "u", :vocal, :notfound},
  #  {11, 8} => {"B", "b", :consonante, :notfound}
  # }


  #Por completar: Generar un mapa donde la clave sea el número/posición y el valor la letra. LISTO
  def raw_positions(pos_pares, sel_letters) do
    Enum.zip(
      Enum.flat_map(pos_pares, fn {x, y} -> [x,y] end),
      Enum.flat_map(sel_letters, fn {x, y, _w, _z} -> [x,y] end))
    |> Map.new
  end

  def compare_pair(par) do
    vowels = ["a", "e", "i", "o", "u"]
    case String.downcase(elem(par,1)) in vowels do
      true -> {:correct, :vocal}
      false -> {:correct, :consonante}
    end
  end

end



#c("lib/memory/memory_utils.ex")
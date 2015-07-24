defmodule Mod do
  def mod(x, y) do
    cond do
      x == 0 -> 0
      x > 0 -> rem(x, y)
      x < 0 -> y + rem(x, y)
    end
  end
end

defmodule Ring do
  def for(integer) do
    do_ring_for(integer, 0)
  end

  defp do_ring_for(integer, ring) do
    if integer < first_int(ring + 1) do
       ring
    else
       do_ring_for(integer, ring + 1)
    end
  end

  def size(ring) do
    6 * ring
  end

  def first_int(ring) do
    # the number on top of the ring, 0-indexed
    cond do
      ring == 0 -> 1
      true -> 3 * ring * (ring - 1) + 2
    end
  end
end

defmodule Coord do
  def for(integer) do
    ring = Ring.for(integer)
    {ring, integer - Ring.first_int(ring)}
  end

  def to_int(ring, position) do
    if ring == 0 do
      1
    else
      Ring.first_int(ring) + Mod.mod(position, Ring.size(ring))
    end
  end
end

defmodule Axis do
  # nearest means the largest axis with a lower position than integer

  def ord_of_nearest(ring, integer) do
    position = integer - Ring.first_int(ring)
    div(position, ring)
  end

  def dist_from_nearest(ring, integer) do
    position = integer - Ring.first_int(ring)
    rem(position, ring)
  end

  def pos_of(ring, axis) do
    ring * axis
  end
end

defmodule Neighbors do
  def all(ring, pos, integer) do
    siblings = [Coord.to_int(ring, pos + 1), Coord.to_int(ring, pos - 1)]
    inners(ring, integer) ++ siblings ++ outers(ring, integer)
  end

  def inners(ring, integer) do
    axis = Axis.ord_of_nearest(ring, integer)

    one_lower = Axis.pos_of(ring - 1, axis)
    distance = Axis.dist_from_nearest(ring, integer)

    if distance == 0 do
      [Coord.to_int(ring - 1, one_lower)]
    else
      [
        Coord.to_int(ring - 1, one_lower + distance - 1),
        Coord.to_int(ring - 1, one_lower + distance)
      ]
    end
  end

  def outers(ring, integer) do
    axis = Axis.ord_of_nearest(ring, integer)

    one_higher = Axis.pos_of(ring + 1, axis)
    distance = Axis.dist_from_nearest(ring, integer)

    if distance == 0 do
      [
        Coord.to_int(ring + 1, one_higher - 1),
        Coord.to_int(ring + 1, one_higher),
        Coord.to_int(ring + 1, one_higher + 1)
      ]
    else
      [
        Coord.to_int(ring + 1, one_higher + distance),
        Coord.to_int(ring + 1, one_higher + distance + 1)
      ]
    end
  end
end

defmodule PrimeETS do
  def init do
    tab = :ets.new(:primes, [:ordered_set])
    :ets.insert(tab, {2})
    tab
  end

  def prime?(table, integer) do
    if integer == 1 do
      false
    else
      extend(table, integer)
      prime = :ets.first(table)
      do_prime?(table, prime, integer)
    end
  end

  defp do_prime?(table, prime, integer) do
    cond do
      prime == :"$end_of_table" -> true
      rem(integer, prime) == 0 -> false
      true ->
        next = :ets.next(table, prime)
        do_prime?(table, next, integer)
    end
  end

  defp extend(table, integer) do
    target = Float.floor(:math.sqrt(integer))
    largest = :ets.last(table)

    if largest < target do
      do_extend(table, largest + 1, target)
    end
  end

  defp do_extend(table, potential_prime, until) do
    if prime?(table, potential_prime) do
      prime = potential_prime

      :ets.insert(table, {prime})
      if prime < until do
        do_extend(table, prime + 1, until)
      end
    else
      do_extend(table, potential_prime + 1, until)
    end
  end
end

defmodule Euler128 do
  import ExProf.Macro

  def is_special?(tab, ring, pos) do
    integer = Coord.to_int(ring, pos)
    neighbors = Neighbors.all(ring, pos, integer)
    prime_diff = fn(x) -> PrimeETS.prime?(tab, abs(x - integer)) end
    Enum.count(neighbors, prime_diff) == 3
  end

  def stream do
    table = PrimeETS.init
    special? = fn({ring, pos}) -> is_special?(table, ring, pos) end

    # no idea why only tiles on this boundary match,
    # but considering the discontinuity there it's reasonable
    coords = Stream.iterate({1, 0}, fn({ring, pos}) ->
      if pos == 0 do
        {ring, Ring.size(ring) - 1}
      else
        {ring + 1, 0}
      end
    end)

    specials = Stream.filter(coords, special?)
    integers = Stream.map(specials, fn({ring, pos}) -> Coord.to_int(ring, pos) end)

    integers
  end

  def analyze(n) do
    profile do
      Enum.take(Euler128.stream(), n)
    end
  end

  def main(n) do
    specials = stream()

    pretty_print = fn(x, index) ->
      IO.puts("#{index}: #{x}")
      index + 1
    end

    limit = Stream.take(specials, n-1)
    # the index starts at 2 because 1 isn't a part of the stream, even though
    # PD(1) = 3.
    Enum.reduce(limit, 2, pretty_print)
  end
end

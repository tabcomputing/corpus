#defmodule Cons do
#  def cons(list, size) do
#    t = :array.from_list(list)
#    :array.to_list(:array.set(0,5,t))
#  end
#end

#IO.puts inspect Cons.cons([1,2,3], 2)

  a = [{"a","x"},{"b","c"}]

  Enum.each Enum.with_index(a), fn({{x, y}, i}) ->
    IO.puts(i)
    IO.puts(x)
    IO.puts(y)
    IO.puts ""
  end




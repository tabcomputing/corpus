defmodule T do

    #
    #
    #
    def unique(list) do
      Enum.reduce list, [], fn(a, c) ->
        cnt = Enum.count(c, fn(x) -> x == a end)
        if cnt == 0 do
          [a | c]
        else
          c
        end
      end
    end

end

list = [ [1,2,3], [1,2,3], [2,3,4] ]

new_list = T.unique(list)

IO.puts inspect(new_list)


#
# Corpus - Kayboard Assesment API
#
# (c) 2013 Tab Computing. All Rights Reserved.
#
defmodule Corpus do

  defmodule Layout do

    #
    defrecord Keyboard, layout: nil, score: nil

    #
    def make_keyboard(layout) do
      Keyboard.new(layout: layout, score: score(layout))
    end

    #
    @numbers %w{1 2 3 4 5 6 7 8 9 0}

    #
    @pairs %w{wh sh th ph ch gh dj ng er an}

    #
    @alphabet %w{a e i o u  w r y h  m n l  s z c x  k g q  p b f v  t d j}

    #
    # Letters with bi-lateral symmetries
    #
    # Other possibles:
    # * {"g","x"} - "x" acts as a stand-in for voiced frictive gutteral
    #
    @symmetries [
      {"t","d"},{"p","b"},{"k","g"},{"f","v"},{"s","z"},{"c","x"},
      {"sh","j"},{"ch","dj"},
      {"m","w"},{"n","r"},{"l","r"},{"n","y"},{"ng","y"},
      {"i","e"},{"o","a"},
      {"p","f"},{"b","v"},{"t","sh"},{"s","th"},{"d","j"},{"k","q"},{"g","gh"},
      {"s","c"},{"z","x"}
    ]

    #
    #
    #
    @symmetric_positions [
      { 0, 8},{ 1, 7},{ 2, 6},{ 3, 5},
      { 9,17},{10,16},{11,15},{12,14},
      {18,26},{19,25},{20,24},{21,23},
      {27,35},{28,34},{29,33},{30,32},
      {10,21},{16,23},{12,19},{14,25}
    ]

    #
    #def random_layouts(num) do
    #  if num do
    #    [@numbers ++ Enum.shuffle(@alphabet)]
    #  else
    #    [@pairs ++ Enum.shuffle(@alphabet)]
    #  end
    #end

    # TODO: make this adjustable via settings
    def numeric_layout? do
      true
    end

    #
    def random_keyboards(n) do
      if numeric_layout? do
        Enum.map 1..n, fn(i) ->
          make_keyboard(@numbers ++ Enum.shuffle(@alphabet))
        end
      else
        Enum.map 1..n, fn(i) ->
          make_keyboard(@pairs ++ Enum.shuffle(@alphabet))
        end
      end
    end

    #
    # Gather the saved layouts and turn them into keyboards.
    #
    def saved_keyboards do
      Enum.map saves, fn(layout) ->
        make_keyboard(layout)
      end
    end

    #
    # Load the saved kayboards and cache them in process variable.
    #
    def saves do
      x = Process.get(:saves, nil)
      if x == nil do
        x = load_saves()
        Process.put(:saves, x)
      end
      x
    end

    #
    # Top 1000 words with ranks, cached in a process variable.
    #
    def words do
      ll = Process.get(:corpus_words, nil)
      if ll == nil do
        ll = load_words(1000)
        Process.put(:corpus_words, ll)
      end
      ll
    end

    #
    # Letters and their ranks, cached in a process variable.
    #
    def letters do
      # to bad we cant just do this
      #Process.get(:corpus_letters, Process.put(:corpus_letters, load_letters))

      ll = Process.get(:corpus_letters, nil)
      if ll == nil do
        ll = load_letters
        Process.put(:corpus_letters, ll)
      end
      ll
    end

    #
    # Read lines of a file.
    #
    def read_lines(file, list) do
      line = IO.read(file, :line)
      if (line != :eof) do
        line = String.strip(line)
        if line == "" || String.first(line) == '#' do
          read_lines(file, list)
        else
          read_lines(file, [line | list])
        end
      else
        list
      end
    end

    #
    def chomp(str) do
      #String.strip(str)
      Regex.replace(%r/\r?\n\z|\r\z/, str, "", [{:global, false}])
    end

    @doc """
    Load saved layouts.
    """
    def load_saves do
      filename = "data/saves.dat"

      if File.exists?(filename) do
        file = File.open!(filename, [:read, :utf8])
        list = read_lines(file, [])

        list = Enum.reduce list, [], fn(line, newlist) ->
          if line == "" || String.first(line) == "#" do
            newlist
          else
            letters = String.split(line, %r/\s+/)
            [letters | newlist]
          end
        end

        list = enum_group(list, 4)

        Enum.map list, fn(letters) ->
          List.concat(letters)
        end
      else
        []
      end
    end

    @doc """
    Returns a new collection with elements grouped into smaller
    collections of a given number of elements.
  
    ## Examples

        iex> Enum.group([:a, :b, :c, :d], 2)
        [[:a, :b], [:c, :d]]

    """
    def enum_group(list, number, base // []) do
      if length(list) == 0 do
        base
      else
        {part, rest} = Enum.split(list, number)
        enum_group(rest, number, List.concat(base, [part]))
      end
    end

    @doc """
    Load word ranks from cache file.
    """
    def load_words(max // 1000) do
      filename = "data/words.dat"

      if File.exists?(filename) do
        file = File.open!(filename, [:read, :utf8])
        list = read_lines(file, [])

        ranklist = Enum.reduce list, [], fn(line, res) ->
          [parse_rank(line) | res]
        end

        ranklist = Enum.sort ranklist, fn(a, b) ->
          {w1, r1} = a
          {w2, r2} = b
          r1 > r2
        end
 
        ranklist = Enum.take(ranklist, max)

        #Enum.each ranklist, fn(entry) ->
        #  IO.puts(inspect(entry))
        #end

        HashDict.new ranklist
      else
        []
      end
    end

    #
    # Load word ranks from cache file.
    #
    def load_letters do
      filename = "data/letters.dat"
      if File.exists?(filename) do
        file = File.open!(filename, [:read, :utf8])

        list = read_lines(file, [])

        data = Enum.reduce list, [], fn(line, res) ->
          [parse_rank(line) | res]
        end

        HashDict.new data
      else
        []
      end
    end

    # TODO: I do not like doing this recursively.
    #def process_file(input_file, listing) do
    #  row = IO.read(input_file, :line)
    #  if (row != :eof) do
    #    process_file(input_file, [parse_rank(String.strip(row)) | listing])
    #  else
    #    listing #Enum.sort(namelist, by_points(&1, &2))
    #  end
    #end

    #
    # Split line string into two on space and convert the
    # first part to a float, then return in reverse order.
    #
    def parse_rank(line) do
      [rank, entry] = String.split(line, %r/\s+/)
      {rank, _} = String.to_float(rank)
      {entry, rank}
    end


    @score_base           0.0
    @score_primary       50.0
    @score_point         50.0
    @score_nonpoint     -50.0
    @score_pinky        -25.0
    @score_horizontal    50.0
    @score_vertical    -100.0
    @score_double_tap   -75.0
    @score_distant      -25.0
    @score_concomitant   50.0
    @score_symmetry      10.0

    #
    # Score a keyboard layout.
    #
    def score(layout) do
      score = Enum.reduce words, 0, fn({word, rank}, sum) ->
        sum + score_word(layout, word, rank)
      end
      #if settings.Symmetric do
        score = score + (symmetry(layout) * @score_symmetry)
      #end
      round(score)
    end

    #
    # Score a layout for a given word.
    #
    def score_word(layout, word, rank) do
      letters = word_letters(layout, String.codepoints(word), [], nil)

      #indexed_letters = Enum.with_index(letters)

      lettering = Enum.with_index(each_cons(List.concat([nil], letters), 2))

      score = Enum.reduce lettering, 0, fn({[last, letter], index}, sum) ->
        significance = 1.0 / (index + 1)

        if Enum.member?(layout, letter) do
          sum + score_letter(layout, letter, last) * significance
        else
          sum
        end
      end

      #cons = each_cons(letters, 2)

      #coscore = Enum.reduce cons, 0, fn([letter1, letter2], sum) ->
      #  if concomitant?(layout, letter1, letter2) do
      #    sum + weigh(letter2, @score_concomitant)
      #  else
      #    sum
      #  end
      #end

      # weigh the score by the word ranking
      score * rank
    end

    #
    #
    #
    def word_letters(layout, [head | rest], letters, last) do
      if head do
        if last do
          pair = last <> head
          if Enum.member?(layout, pair) do
            letter = pair
          else
            letter = head
          end
        else
          letter = head
        end

        word_letters(layout, rest, [letter | letters], head)
      else
        letters
      end
    end

    #
    # Word letters for empty word list.
    #
    def word_letters(layout, [], letters, last) do
      layout  # shut-up!
      last    # shut-up!
      letters
    end

    #
    #
    #
    def score_letter(layout, letter, last) do
      score = @score_base

      if primary?(layout, letter),    do: score = score + @score_primary
      if point?(layout, letter),      do: score = score + @score_point
      if nonpoint?(layout, letter),   do: score = score + @score_nonpoint
      if pinky?(layout, letter),      do: score = score + @score_pinky
      if horizontal?(layout, letter), do: score = score + @score_horizontal
      if vertical?(layout, letter),   do: score = score + @score_vertical   
      if double_tap?(layout, letter), do: score = score + @score_double_tap
      if distant?(layout, letter),    do: score = score + @score_distant

      if last && concomitant?(layout, last, letter) do
        score = score + @score_concomitant
      end

      weigh(letter, score)
    end

    #
    #
    #
    def weigh(letter, points) do
      if HashDict.has_key?(letters, letter) do
        points * HashDict.get(letters, letter)
      else
        points
      end
    end

    #
    # Anything starting on the primary row (the bottom row) is better.
    #
    def primary?(layout, letter) do
      index = Enum.find_index(layout, fn(x) -> x == letter end)
      index && index >= 18 && index <= 35
    end

    #
    # Any action that keeps the first finger on the lower left key is
    # better (from right handed perspective).
    #
    def point?(layout, letter) do
      index = Enum.find_index(layout, fn(x) -> x == letter end)
      Enum.member?([12, 15, 19, 20, 27, 28, 29, 30, 33], index)
    end

    #
    # Any action that forces the first finger to move up is bad
    # (from right handed perspective).
    #
    def nonpoint?(layout, letter) do
      index = Enum.find_index(layout, fn(x) -> x == letter end)
      Enum.member?([0, 1, 2, 9, 10, 11, 3, 6, 18, 21, 24], index)
    end

    #
    # Having to move up the weak finger sucks too.
    #
    def pinky?(layout, letter) do
      index = Enum.find_index(layout, fn(x) -> x == letter end)
      Enum.member?([6, 7, 8, 15, 16, 17, 20, 23, 26], index)
    end

    #
    # Horizontal actions are generally better than diagonal ones.
    #
    def horizontal?(layout, letter) do
      index = Enum.find_index(layout, fn(x) -> x == letter end)
      if index do
        (index >= 0  && index <= 8) || (index >= 27 && index <= 35)
      else
        false
      end
    end

    #
    # Vertical actions are the worst.
    #
    def vertical?(layout, letter) do
      index = Enum.find_index(layout, fn(x) -> x == letter end)
      Enum.member?([9, 13, 17, 18, 22, 26], index)
    end

    #
    # Letters that require a double tap of the same key arent ideal either.
    #
    def double_tap?(layout, letter) do
      index = Enum.find_index(layout, fn(x) -> x == letter end)
      Enum.member?([0, 4, 8, 27, 31, 35], index)
    end

    #
    # Letters that require distant keystrokes are not so good.
    #
    def distant?(layout, letter) do
      index = Enum.find_index(layout, fn(x) -> x == letter end)
      Enum.member?([2, 6, 11, 15, 20, 24, 29, 33], index)
    end

    #
    # Too letters are concomitant if the first letter ends on the key
    # that the second letter begins. This is a good thing.
    #
    def concomitant?(layout, letter1, letter2) do
      i1 = Enum.find_index(layout, fn(x) -> x == letter1 end)
      i2 = Enum.find_index(layout, fn(x) -> x == letter2 end)

      if i1 && i2 do
        c1 = rem i1, 6
        c2 = div i2, 6
        (c1 == c2)
      else
        false
      end
    end

    #
    # Counts the number of symmetries in a layout.
    #
    def symmetry(layout) do
      Enum.reduce @symmetric_positions, 0, fn({p0, p1}, c1) ->
        c1 + Enum.reduce @symmetries, 0, fn({q0, q1}, c2) ->
          if (Enum.at(layout, p0) == q0 && Enum.at(layout, p1) == q1) ||
             (Enum.at(layout, p0) == q1 && Enum.at(layout, p1) == q0) do
            c2 + 1
          else
            c2
          end
        end
      end
    end

    #
    # Cons
    #
    def each_cons(list, n // 2), do: _each_cons(list, n, [])

    defp _each_cons(list,  n, result) when length(list) < n do
      Enum.reverse result
    end

    defp _each_cons(list = [_ | tail], n, result) do
      _each_cons(tail, n, [Enum.take(list, n) | result])
    end

    #
    # Evolve a population.
    #
    # gen - number of generations
    #
    def evolve(gen) do
      :random.seed(:erlang.now())
      evolve(gen, gen, random_keyboards(16), 16, 0)
    end

    #
    # Evolve a single generation.
    #
    # gen  - genration count down
    # pop  - population of keyboards
    # size - maximum size of the population allowed
    # best - highest score within the population
    #
    def evolve(gen, max, pop, size, best) do
      if gen == 0 do
        pop
      else
        {_, t0, _} = :erlang.now() 

        IO.write("Generation ##{max - gen + 1} - ")

        children = breed(pop)  # TODO: Add cloning?
        newpop   = List.concat(children, pop)
        newpop   = natural_selection(newpop, size)

        display_population(newpop)

        {_, t1, _} = :erlang.now() 
        IO.puts("Finished in #{t1 - t0} seconds.")

        first = Enum.at(newpop, 0)

        IO.puts "\nBest result:"
        display(first)

        if best < first.score do
          evolve(gen - 1, max, newpop, 16, first.score)
        else
          evolve(gen - 1, max, newpop, size + 2, best)
        end
      end
    end

    #
    # Display a keyboard.
    #
    def display(keyboard) do
      f = "~2s ~2s ~2s  ~2s ~2s ~2s  ~2s ~2s ~2s\n"
      s = keyboard.layout
      :io.fwrite f, Enum.take(s, 9)
      s = Enum.drop(s, 9)
      :io.fwrite f, Enum.take(s, 9)
      s = Enum.drop(s, 9)
      :io.fwrite f, Enum.take(s, 9)
      s = Enum.drop(s, 9)
      :io.fwrite f, Enum.take(s, 9)
      IO.puts "Score: #{keyboard.score}"
      IO.puts ""
    end

    #
    #
    #
    def display_population(pop) do
      IO.puts ""
      Enum.each pop, fn(p) ->
        Enum.each p.layout, fn(x) ->
          :io.fwrite("~3s", [x])
        end
        IO.puts "  #{p.score}"
      end
      IO.puts ""
    end

    #
    # Selects population to survive and recombine.
    #
    def natural_selection(pop, max) do
      if length(pop) > max do
        Enum.take(sort_population(pop), max)
      else
        sort_population(pop)
      end
    end

    #
    # Sort population, highest fitness first. 
    #
    def sort_population(pop) do
      Enum.sort pop, fn(a, b) ->
        a.score > b.score
      end
    end

    #
    # Sex!
    #
    def breed(pop) do
      #if debug() { IO.puts "Breeding " ++ length(pop) ++ " layouts\n") }
      IO.puts "Breeding #{length(pop)} layouts"

      rpop  = randomize_population(pop)
      pairs = each_cons(rpop, 2)

      Enum.map pairs, fn([a, b]) ->
        cross(a, b)
      end
    end

    #
    # Asex! Asexual reproduction copies the parent and applies mutations.
    #
    def clone(pop) do
      #if debug() { IO.puts "Breeding " ++ length(pop) ++ " layouts\n") }
      IO.write "Breeding #{length(pop)} layouts "

      rpop = randomize_population(pop)

      Enum.map rpop, fn(k) ->
        mutate(k)
      end
    end

    #
    # Crossbreed two layouts.
    #
    def cross(mother, father) do
      offset = 0

      if numeric_layout?() do
        offset = 9
      end

      n = number_of_actions(1)

      #s = :random.uniform(length(mother.layout) - offset - 1) + offset
      #n = :random.uniform(length(mother.layout) - offset - 1) + offset

      #if s > n do
      #  t = s
      #  s = n
      #  n = t
      #end

      #child_layout = Enum.reduce (s .. n), mother.layout, fn(i, c) -> 
      child_layout = Enum.reduce (0 .. n), mother.layout, fn(i, c) ->
        i = :random.uniform(length(c) - offset - 1) + offset
        l = Enum.at father.layout, i
        x = Enum.find_index(c, fn(q) -> q == l end)
        if x do
          #replace_at(swap(c, x, i), i, l)
          swap(c, x, i)
        else
          c  # should generally never happen
        end
      end

      # TODO: ensure no duplicates
      #dups = duplicates(child)
      #if length(dups) > 0 do
      #  IO.printf("ERROR: duplicates from sex!\n%s\n%s\n%s\n%s", dups, mother, father, child)
      #end

      make_keyboard(mutate(child_layout))
    end

    #
    def swap(list, i1, i2) do
       x1 = Enum.at(list, i1)
       x2 = Enum.at(list, i2)
       a = :array.from_list(list)
       a = a.set(i2, x1)
       a = a.set(i1, x2)
       :array.to_list(a)
    end

    #
    def replace_at(list, i, x) do
       a = :array.from_list(list)
       a = a.set(i, x)
       :array.to_list(a)
    end

    #
    # Evolutionary mutation, by swapping two positions.
    #
    def mutate(layout) do
      offset = 0

      if numeric_layout?() do
        offset = 9
      end

      # mutations occur only half of the time
      n = number_of_actions(0)

      Enum.reduce (0 .. n), layout, fn(i, mutant) ->
        i1 = :random.uniform(length(layout) - offset - 1) + offset
        i2 = :random.uniform(length(layout) - offset - 1) + offset

        swap(mutant, i1, i2)
      end
    end

    #
    # Returns `num` half of time. The other half of the time
    # it calls itslef with `num+1`. So `num+1` will be returned
    # a quater of the time. And so on with higher numbers.
    #
    defp number_of_actions(num) do
      if :random.uniform(2) == 1 do
        num
      else
        number_of_actions(num + 1)
      end
    end

    #
    # Randomize the order of a population.
    #
    def randomize_population(pop) do
      Enum.shuffle(pop)
    end

  end

end

#Enum.each layouts, fn(layout) -> 
#  #IO.puts name
#  IO.puts Corpus.Layout.score(layout) 
#end

cmd = Enum.at(System.argv, 0)

if cmd == "score" do
  IO.puts("Scoring...\n")
  list = Corpus.Layout.saved_keyboards()
  Enum.each list, fn(k) ->
    #IO.puts n
    Corpus.Layout.display(k)
    IO.puts ""
  end
else  # 'evolve'
  gen = Enum.at(System.argv, 1)
  if gen do
    {gen, _} = String.to_integer(gen)
  else
    gen = 128
  end
  IO.puts("Evolving...\n")
  Corpus.Layout.evolve(gen)
end


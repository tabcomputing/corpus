defmodule Corpus do

  defmodule Layout do

    #
    @numbers %w{1 2 3 4 5 6 7 8 9 0}

    #
    @pairs %w{wh sh th ph ch gh dj ng er an}

    #
    @alphabet %w{a e i o u  w r y h  m n l  s z c x  k g q  p b f v  t d j}

    # Ergonmic (very ergonomic but maybe too weird)
    @layout_numeric_point %w{
      4  x  v    j  5  r    k  g  0
      z  p  u    l  y  b    c  f  6
      7  n  h    d  8  w    q  m  9
      1  a  e    t  2  s    i  o  3
    }

    @layout_topside_compromise %w{
      gh th ng   4  ch wh   7  sh 9
      u  b  p    r  l  w    f  v  0
      g  h  n    k  j  q    m  y  x
      d  t  e    a  c  o    i  s  z 
    }

    @layout_numeric_compromise %w{
      1  2  3    4  5  6    7  8  9
      u  b  p    r  l  w    f  v  0
      g  h  n    k  j  q    m  y  x
      d  t  e    a  c  o    i  s  z 
    }

    @layout_topside_second %w{
      gh th ng   4  ch 6    wh sh 9
      g  k  r    u  l  0    w  q  x
      b  p  n    h  j  y    m  f  v
      d  t  e    a  c  o    i  s  z 
    }

    @layout_numeric_second %w{
      1  2  3   4  5  6   7  8  9
      g  k  w   c  r  j   y  q  x
      b  p  m   h  l  0   n  f  v
      d  t  e   a  u  i   o  s  z 
    }

    @layout_topside_third %w{
      gh qu ng  th ch sh  wh ph -
      q  g  k   n  r  l   w  f  0
      x  i  h   d  j  z   p  b  v
      y  e  a   t  c  s   m  o  u 
    }

    # Ergonomic (my original hand made version)
    @layout_numeric_original %w{
      1  2  3    4  5  6    7  8  9
      z  g  k    n  v  m    w  r  0
      x  t  s    b  j  d    f  c  q
      p  a  e    o  u  h    i  l  y 
    }

    @layout_topside_alternate %w{
      gh ph ng   th sh wh   ch 8  qu
      z  p  u    l  v  f    c  b  0
      x  h  n    d  j  w    m  r  q
      g  a  e    t  y  s    i  o  k
    }

    @layout_numeric_phonetic %w{
      1  2  3    4  5  6    7  8  9
      0  u  y    n  r  l    m  h  w
      g  e  x    d  j  z    b  i  v
      k  a  q    t  c  s    p  o  f
    }

    @layout_topside_addendum %w{
      gh 2  3    th ch sh   ph 8  wh
      0  u  y    n  r  l    m  h  w
      g  e  x    d  j  z    b  i  v
      k  a  q    t  c  s    p  o  f
    }

    @layout_advanced_symmetric %w{
      f  sh qu   m  wh w    gh j  v
      c  ch th   n  l  r    th dj x
      p  t  k    ng u  y    g  d  b
      ph o  s    i  h  e    z  a  -
    }

    @layout_advanced_acoustic %w{
      f  ch qu   wh h  er   -  l  an
      v  th gh   w  r  y    m  n  ng
    	u  o  a    z  j  x    b  d  g
      y  i  e    s  sh c    p  t  k 
    }

    @layout_advanced_articulate %w{
      x  g  ng   o  wh i    m  b  v
      q  k  y    -  -  -    w  p  f
      j  d  n    -  -  -    l  z  th
      sh t  r    a  u  e    h  s  c 
    }

    @layout_advanced_articulate_plus %w{
      x  q  y    o  wh i    w  f  v
      g  k  ng   -  -  -    m  p  b
      j  sh r    -  -  -    h  th c
      d  t  n    a  u  e    l  s  z
    }

    def predefined_layout_names do
      [ "Numeric Point",
        "Topside Compromise",
        "Numeric Compromise",
        "Topside Second",
        "Numeric Second",
        "Topside Thrid",
        "Numeric Original",
        "Topside Alternate",
        "Numeric Phonetic",
        "Topside Addendum",
        "Advanced Symmetric",
        "Advanced Acoustic",
        "Advanced Articulate",
        "Advanced Articulate Plus"
      ]
    end

    def predefined_layouts do
      [
        @layout_numeric_point,
        @layout_topside_compromise,
        @layout_numeric_compromise,
        @layout_topside_second,
        @layout_numeric_second,
        @layout_topside_third,
        @layout_numeric_original,
        @layout_topside_alternate,
        @layout_numeric_phonetic,
        @layout_topside_addendum,
        @layout_advanced_symmetric,
        @layout_advanced_acoustic,
        @layout_advanced_articulate,
        @layout_advanced_articulate_plus
      ]
    end

    #
    def random_layouts(num) do
      if num do
        [@layout_numeric_compromise, @numbers ++ Enum.shuffle(@alphabet)]
      else
        [@layout_topside_compromise, @pairs ++ Enum.shuffle(@alphabet)]
      end
    end

    #
    # Top 1000 words with ranks.
    #
    def words do
      ll = Process.get(:corpus_letters, nil)
      if ll == nil do
        ll = load_words(1000)
        Process.put(:corpus_words, ll)
      end
      ll
    end

    #
    # Letters and their ranks.
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
    def population do
      [random, @layout_advanced_acoustic]
    end

    #
    def population_numeric do
      [random_numeric, @layout_numeric_compromise]
    end

    #
    def random do
      Enum.shuffle(@letters1)
    end

    #
    def random_numeric do
      [1, 2, 3, 4, 5, 6, 7, 8, 9, 0] ++ Enum.shuffle(@alphabet)
    end

    #
    # Load word ranks from cache file.
    #
    def load_words(max // 1000) do
      filename = "data/words.dat"
      if File.exists?(filename) do
        input_file = File.open!(filename, [:read, :utf8])

        ranklist = process_file(input_file, [])

        ranklist = Enum.sort(ranklist, &2 > &1)
        ranklist = Enum.take(ranklist, max)

        #h = {}
        #Enum.each a.each do |(word, rank)|
        #  Keyword.put(h, word, float(rank))
        #end
        #h
        HashDict.new ranklist
      else
        nil
      end
    end

    #
    # Load word ranks from cache file.
    #
    def load_letters do
      filename = "data/letters.dat"
      if File.exists?(filename) do
        input_file = File.open!(filename, [:read, :utf8])
        HashDict.new process_file(input_file, [])
      else
        nil
      end
    end

    #
    def process_file(input_file, listing) do
      row = IO.read(input_file, :line)
      if (row != :eof) do
        process_file(input_file, [process_row(row) | listing])
      else
        listing #Enum.sort(namelist, by_points(&1, &2))
      end
    end

    #
    def process_row(row) do
      srow = String.strip(row) #chomp(row))
      [rank, entry] = String.split(srow, %r/\s+/)
      {rank, _} = String.to_float(rank)
      {entry, rank}
    end

    
    #
    def chomp(str) do
      #String.strip(str)
      Regex.replace(%r/\r?\n\z|\r\z/, str, "", [{:global, false}])
    end

    @score_base           0
    @score_primary       50
    @score_point         50
    @score_nonpoint     -50
    @score_pinky        -25
    @score_horizontal    50
    @score_vertical    -150
    @score_double_tap  -100
    @score_concomitant   50

    #
    # Score the layout.
    #
    def score(layout) do
      score = Enum.reduce words, 0, fn({word, rank}, sum) ->
        sum + score_word(layout, word, rank)
      end
      round(score)
    end

    #
    #
    #
    def score_word(layout, word, rank) do
      word = String.codepoints(word)

      letters = word_letters(layout, word, [], nil)

      #letters = Enum.map word, fn(char) ->
      #  pair = elem(word, index) ++ elem(word, index+1)
      #  if elem(word, index+1) && Enum.member?(layout, pair) do
      #    letter = pair
      #  else
      #    letter = elem(word, index)
      #  end
      #end

      # TODO: while loop
      #while index < word.size do
      #  pair = elem(word, index) ++ elem(word, index+1)
      #  if elem(word, index+1) && Enum.member?(layout, pair) do
      #    letter = pair
      #  else
      #    letter = elem(word, index)
      #  end

      #indexed_letters = Enum.with_index(letters)

      score = Enum.reduce letters, 0, fn(letter, sum) ->
        if Enum.member?(layout, letter) do
          #deduction = (index * 10)  # first letters are more significant
          sum + score_letter(layout, letter) #- deduction
        else
          sum
        end
      end

      cons = each_cons(letters, 2)

      coscore = Enum.reduce cons, 0, fn([letter1, letter2], sum) ->
        if concomitant?(layout, letter1, letter2) do
          sum + weigh(letter2, @score_concomitant)
        else
          sum
        end
      end

      # weigh the score by the word ranking
      (score + coscore) * rank
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
    def score_letter(layout, letter) do
      score = @score_base

      if primary?(layout, letter),    do: score = score + @score_primary
      if point?(layout, letter),      do: score = score + @score_point
      if nonpoint?(layout, letter),   do: score = score + @score_nonpoint
      if pinky?(layout, letter),      do: score = score + @score_pinky
      if horizontal?(layout, letter), do: score = score + @score_horizontal
      if vertical?(layout, letter),   do: score = score + @score_vertical   
      if double_tap?(layout, letter), do: score = score + @score_double_tap

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
    # pop - initial population
    # gen - number of generations
    #
    def evolve(pop, gen) do
      :random.seed
      Enum.reduce (1 .. gen), pop, fn(i, p) ->
        p = List.concat(breed(p), p)
        p = natural_selection(p, 8)
        Enum.each p, fn(x) ->
          display(x)
        end
        p
      end
    end

    #
    #
    #
    def display(layout) do
      f = "~2s ~2s ~2s | ~2s ~2s ~2s | ~2s ~2s ~2s\n"
      s = layout
      :io.fwrite f, Enum.take(s, 9)
      s = Enum.drop(s, 9)
      :io.fwrite f, Enum.take(s, 9)
      s = Enum.drop(s, 9)
      :io.fwrite f, Enum.take(s, 9)
      s = Enum.drop(s, 9)
      :io.fwrite f, Enum.take(s, 9)
      IO.puts "Score: #{score(layout)}"
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
        score(a) > score(b)
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
        mutate(cross(a, b))
      end
    end

    #
    # Crossbreed two layouts.
    #
    def cross(mother, father) do
      offset = 0
      if top_numbers() do
        offset = 9
      end

      s = :random.uniform(length(mother) - offset - 1) + offset
      n = :random.uniform(length(mother) - offset - 1) + offset

      if s > n do
        t = s
        s = n
        n = t
      end
 
      Enum.reduce (s .. n), mother, fn(i, child) ->
        c = Enum.at father, i
        x = Enum.find_index(child, fn(q) -> q == c end)
        if x do
          replace_at(swap(child, x, i), i, c)
        else
          child
        end
      end

      #dups = duplicates(child)
      #if length(dups) > 0 do
      #  IO.printf("ERROR: duplicates from sex!\n%s\n%s\n%s\n%s", dups, mother, father, child)
      #end
    end

    def swap(list, i1, i2) do
       x1 = Enum.at(list, i1)
       x2 = Enum.at(list, i2)
       a = :array.from_list(list)
       a.set(i2, x1)
       a.set(i1, x2)
       :array.to_list(a)
    end

    def replace_at(list, i, x) do
       a = :array.from_list(list)
       a.set(i, x)
       :array.to_list(a)
    end

    #
    # Evolutionary mutation, by swapping two positions.
    #
    def mutate(layout) do
      offset = 0
      if top_numbers() do
        offset = 9
      end

      # 50% of the time no mutation occurs
      if :random.uniform(2) == 1 do
        i1 = :random.uniform(length(layout) - offset - 1) + offset
        i2 = :random.uniform(length(layout) - offset - 1) + offset

        mutant = swap(layout, i1, i2)

        #dups   := duplicates(mutant)
        #if len(dups) > 0 do
        #  fmt.Printf("Duplicate letter from mutation!\n%s", mutant)
        #end

        mutant
      else
        layout
      end
    end

    #
    # Randomize the order of a population.
    #
    def randomize_population(pop) do
      Enum.shuffle(pop)
    end

    #
    #
    #
    def top_numbers do
      true
    end

  end

end

#Enum.each layouts, fn(layout) -> 
#  #IO.puts name
#  IO.puts Corpus.Layout.score(layout) 
#end

layouts = Corpus.Layout.random_layouts(true)
Corpus.Layout.evolve(layouts, 4)


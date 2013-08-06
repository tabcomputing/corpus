module Corpus

  class Layout

    #
    LETTERS1 = %w{ a e i o u  w r y h  m n l ng  s z c x  k g q  p b f v  t d j  wh ch ph th gh sh dj - - }

    #
    LETTERS2 = %w{ a e i o u  w r y h  m n l s z c x  k g q  p b f v  t d j 0 1 2 3 4 5 6 7 8 9 }

    #
    ALPHABET = %w{ a e i o u  w r y h  m n l  s z c x  k g q  p b f v  t d j }

    #
    LAYOUTS = {}
    LAYOUTS_NUMERIC = {}

    # Ergonmic (very ergonomic but maybe too weird)
    LAYOUTS_NUMERIC["Numeric Point"] = [
      "4", "x", "v",  "j", "5", "r",  "k", "g", "0",
      "z", "p", "u",  "l", "y", "b",  "c", "f", "6",
      "7", "n", "h",  "d", "8", "w",  "q", "m", "9",
      "1", "a", "e",  "t", "2", "s",  "i", "o", "3" 
    ]

    LAYOUTS["Compromise"] = [
      "gh","th","ng", "4", "ch","wh", "7", "sh","9",
      "u", "b", "p",  "r", "l", "w",  "f", "v", "0",
      "g", "h", "n",  "k", "j", "q",  "m", "y", "x",
      "d", "t", "e",  "a", "c", "o",  "i", "s", "z" 
    ]

    LAYOUTS_NUMERIC["Numeric Compromise"] = [
      "1", "2", "3",  "4", "5", "6",  "7", "8", "9",
      "u", "b", "p",  "r", "l", "w",  "f", "v", "0",
      "g", "h", "n",  "k", "j", "q",  "m", "y", "x",
      "d", "t", "e",  "a", "c", "o",  "i", "s", "z" 
    ]

    LAYOUTS["Compromise 2"] = [
      "gh","th","ng", "4","ch", "6",  "wh","sh","9",
      "g", "k", "r",  "u", "l", "0",  "w", "q", "x",
      "b", "p", "n",  "h", "j", "y",  "m", "f", "v",
      "d", "t", "e",  "a", "c", "o",  "i", "s", "z" 
    ]

    LAYOUTS_NUMERIC["Numeric Compromise 2"] = [
      "1", "2", "3",  "4", "5", "6",  "7", "8", "9",
      "g", "k", "w",  "c", "r", "j",  "y", "q", "x",
      "b", "p", "m",  "h", "l", "0",  "n", "f", "v",
      "d", "t", "e",  "a", "u", "i",  "o", "s", "z" 
    ]

    LAYOUTS["Compromise 3"] = [
      "gh","qu","ng", "th","ch","sh", "wh","ph","-",
      "q", "g", "k",  "n", "r", "l",  "w", "f", "0",
      "x", "i", "h",  "d", "j", "z",  "p", "b", "v",
      "y", "e", "a",  "t", "c", "s",  "m", "o", "u" 
    ]

    # Ergonomic (my original hand made version)
    LAYOUTS_NUMERIC["Numeric Ergonomic Original"] = [
      "1", "2", "3",  "4", "5", "6",  "7", "8", "9",
      "z", "g", "k",  "n", "v", "m",  "w", "r", "0",
      "x", "t", "s",  "b", "j", "d",  "f", "c", "q",
      "p", "a", "e",  "o", "u", "h",  "i", "l", "y" 
    ]

    LAYOUTS["Addendum Ergonomic Alternate"] = [
      "gh","ph","ng", "th","sh","wh", "ch","8", "qu",
      "z", "p", "u",  "l", "v", "f",  "c", "b", "0",
      "x", "h", "n",  "d", "j", "w",  "m", "r", "q",
      "g", "a", "e",  "t", "y", "s",  "i", "o", "k" 
    ]

    LAYOUTS_NUMERIC["Numeric Phonetic"] = [
      "1", "2", "3",  "4", "5", "6",  "7", "8", "9",
      "0", "u", "y",  "n", "r", "l",  "m", "h", "w",
      "g", "e", "x",  "d", "j", "z",  "b", "i", "v",
      "k", "a", "q",  "t", "c", "s",  "p", "o", "f" 
    ]

    LAYOUTS["Addendum Phonetic"] = [
      "gh","2", "3", "th","ch","sh", "ph", "8", "wh",
      "0", "u", "y",  "n", "r", "l",  "m", "h", "w",
      "g", "e", "x",  "d", "j", "z",  "b", "i", "v",
      "k", "a", "q",  "t", "c", "s",  "p", "o", "f"
    ]

    LAYOUTS["Phonetic Symmetric"] = [
      "f", "sh","qu", "m", "wh","w",  "gh","j", "v",
      "c", "ch","th", "n", "l", "r",  "th","dj","x",
      "p", "t", "k",  "ng","u", "y",  "g", "d", "b",
      "ph","o", "s",  "i", "h", "e",  "z", "a", "'" 
    ]

    LAYOUTS["Phonetic Acoustic"] = [
      "f", "ch","qu", "wh","h", "er", "'", "l", "an",
      "v", "th","gh", "w", "r", "y",  "m", "n", "ng",
    	"u", "o", "a",  "z", "j", "x",  "b", "d", "g",  
      "y", "i", "e",  "s", "sh","c",  "p", "t", "k" ]

    LAYOUTS["Phonetic Articulate"] = [
       "x", "g", "ng", "o","wh", "i",  "m", "b", "v",
       "q", "k", "y",  "-", "-", "-",  "w", "p", "f",
       "j", "d", "n",  "-", "-", "-",  "l", "z", "th",
       "sh","t", "r",  "a", "u", "e",  "h", "s", "c" 
    ]

    LAYOUTS["Phonetic Articulate Plus"] = [
      "x", "q", "y",  "o", "wh","i",  "w", "f", "v",
      "g", "k","ng",  "-", "-", "-",  "m", "p", "b",
      "j", "sh","r",  "-", "-", "-",  "h", "th","c",
      "d", "t", "n",  "a", "u", "e",  "l", "s", "z" 
    ]

    LAYOUTS.merge!(LAYOUTS_NUMERIC)

    #
    ORDER1 = [
      28, 21, 22,      23, 29, 13,     24, 14, 30,
      31, 15, 16,       8, 32, 12,     10, 20, 33,

      34,  7,  9,      17, 35, 19,     18, 11, 36,
      25,  1,  3,       2, 26,  5,      4,  6, 27
    ]

    #
    ORDER2 = [
       30, 23, 24,     21, 28, 15,    22, 16, 29,
       35, 19, 20,      9, 31, 11,    10, 12, 33,

       36,  7,  8,     17, 32, 14,    18, 13, 34,
       25,  1,  2,      3, 26, 6,     5,  4,  27,
    ]

    #
    def self.random(corpus)
      letters = %w{1 2 3 4 5 6 7 8 9 0} + ALPHABET.shuffle
      new(letters, corpus)
    end

    #
    def self.population(corpus)
      letters = %w{1 2 3 4 5 6 7 8 9 0} + ALPHABET.shuffle
      good_start = LAYOUTS["Numeric Compromise"]

      [new(good_start, corpus), new(letters, corpus)]
    end

    #
    #def self.maximum
    #  layout = ORDER1.dup
    #  ordered_letters = LETTER_VALUES.sort_by{ |l, p| p }.reverse.map{ |(l, p)| l }
    #  ordered_letters.each_with_index do |l, i|
    #    index = layout.index(i+1)
    #    layout[index] = l
    #  end
    #  new(layout)
    #end

    #
    def self.permutations(corpus)
      LETTERS1.permutation.each do |letters|
        yield(new(letters, corpus))
      end
    end

    #
    # Initialize new instance of Layout.
    #
    # layout - [Array<String>]
    # corpus - Instance of [Corpus].
    #
    def initialize(layout, corpus)
      @layout  = layout
      @corpus  = corpus

      @weights = ORDER1.map{ |o| o * 10 }  # DEPRECATED
    end

    #
    # Array of layout.
    #
    def layout
      @layout
    end

    #
    # The Corpus instance used to score the layout.
    #
    def corpus
      @corpus
    end

    #
    # Top 1000 words with ranks.
    #
    def words
      @words ||= (
        load_words(1000) || corpus.words.to_h(1000)
      )
    end

    #
    # Top 1000 words with ranks.
    #
    def letters
      @letters ||= (
        load_letters || corpus.letters
      )
    end

    #
    # Score the layout.
    #
    # corpus - Instance of Corpus.
    #
    def score
      @score ||= (
        total = 0
        words.each do |word, rank|
          total += score_word(word, rank)
        end
        total
      )
    end

    SCORE_BASE        =  150
    SCORE_PRIMARY     =  50
    SCORE_POINT       =  50
    SCORE_NONPOINT    = -50
    SCORE_PINKY       = -25
    SCORE_HORIZONTAL  =  50
    SCORE_VERTICAL    = -150
    SCORE_DOUBLE_TAP  = -100
    SCORE_CONCOMITANT =  100

    #
    # Lower the score the better.
    #
    def score_word(word, rank)
      score = 0.0
      last  = nil
      index = 0

      while index < word.size
        if word[index+1] && layout.include?(word[index] + word[index+1])
          letter = word[index] + word[index+1]
        else
          letter = word[index]
        end

        if layout.include?(letter)
          letter_score = 0.0

          #score += weight(letter)
          letter_score += weigh(letter, SCORE_BASE)
          letter_score += weigh(letter, SCORE_PRIMARY)     if primary?(letter)
          letter_score += weigh(letter, SCORE_POINT)       if point?(letter)
          letter_score += weigh(letter, SCORE_NONPOINT)    if nonpoint?(letter)
          letter_score += weigh(letter, SCORE_PINKY)       if pinky?(letter)
          letter_score += weigh(letter, SCORE_HORIZONTAL)  if horizontal?(letter)
          letter_score += weigh(letter, SCORE_VERTICAL)    if vertical?(letter)
          letter_score += weigh(letter, SCORE_DOUBLE_TAP)  if double_tap?(letter)
          letter_score += weigh(letter, SCORE_CONCOMITANT) if concomitant?(last, letter)

          last = letter

          # first letters are more significant
          letter_score -= (index * 10)

          score += letter_score
        end

        index += letter.size
      end

      # weight the score by the word ranking
      score = score * rank

      score.to_i
    end

    #
    #
    #
    def weigh(letter, points)
      points *= (letters[letter] || 1)
    end

    #
    # Anything starting on the primary row (the bottom row) is better.
    #
    def primary?(letter)
      index = @layout.index(letter)
      return false unless index
      return true if index >= 18 && index <= 35
      return false
    end

    #
    # Any action that keeps the first finger on the lower left key is
    # better (from right handed perspective).
    #
    def point?(letter)
      index = @layout.index(letter)
      [12, 15, 19, 20, 27, 28, 29, 30, 33].include?(index)
    end

    #
    # Any action that forces the first finger to move up is bad
    # (from right handed perspective).
    #
    def nonpoint?(letter)
      index = @layout.index(letter)
      [0, 1, 2, 9, 10, 11, 3, 6, 18, 21, 24].include?(index)
    end

    #
    # Having to move up the weak finger sucks too.
    #
    def pinky?(letter)
      index = @layout.index(letter)
      [6, 7, 8, 15, 16, 17, 20, 23, 26].include?(index)
    end

    #
    # Horizontal actions are generally better than diagonal ones.
    #
    def horizontal?(letter)
      index = @layout.index(letter)
      return false unless index
      return true if index >= 0  && index <= 8
      return true if index >= 27 && index <= 35
      return false
    end

    #
    # Vertical actions are the worst.
    #
    def vertical?(letter)
      index = @layout.index(letter)
      return false unless index
      [9, 13, 17, 18, 22, 26].include?(index)
    end

    #
    # Letters that require a double tap of the same key aren't ideal either.
    #
    def double_tap?(letter)
      index = @layout.index(letter)
      return false unless index
      [0, 4, 8, 27, 31, 35].include?(index)
    end

    #
    # Too letters are concomitant if the first letter ends on the key
    # that the second letter begins. This is a good thing.
    #
    def concomitant?(letter1, letter2)
      return false if letter1.nil? || letter2.nil?

      i1 = @layout.index(letter1)
      i2 = @layout.index(letter2)

      return false if i1.nil? || i2.nil?

      c1 = i1 % 6
      c2 = i2 / 6

      c1 == c2
    end

    # DEPRECATED
    def order_weight(letter)
      index = @layout.index(letter)
      index ? @weights[index] : 0
    end

    #
    def to_s
      l = layout
      a = []
      a << "%2s %2s %2s | %2s %2s %2s | %2s %2s %2s" % l[0,9]
      a << "%2s %2s %2s | %2s %2s %2s | %2s %2s %2s" % l[9,9]
      a << "------------------------------"
      a << "%2s %2s %2s | %2s %2s %2s | %2s %2s %2s" % l[18,9]
      a << "%2s %2s %2s | %2s %2s %2s | %2s %2s %2s" % l[27,9]
      a.join("\n")
    end

    #
    def inspect
      "<" + layout.join(' ') + ">"
    end

    #
    # A layout is top-numbered if the top row is always numbers.
    #
    def top_numbers?
      true
    end

    #
    #
    #
    def size
      layout.size
    end

    #
    # Evolutionary fitness
    #
    def fitness
      score
    end

    #
    # Evolutionary reproduction.
    #
    def recombine(mate)
      father = mate.layout
      mother = layout
      child  = mother.dup

      offset = if top_numbers? then 9 else 0 end
      
      s = (rand * (size - offset)).to_i + offset
      n = (rand * (size - offset)).to_i + offset

      s, n = n, s if s > n     

      (s..n).each do |i|
        c = father[i]
        x = child.index(c)

        if x
          child[x] = child[i]
          child[i] = c
        end
      end

      if child.uniq.length != child.length
        dups = child.map{ |c| child.count(c) > 1 ? c : nil }.compact.uniq
        raise "Duplicate letters from sex!\n#{dups}\n#{inspect}\n#{mate.inspect}\n<#{child.join(' ')}>"
      end

      [Layout.new(child, corpus)]
    end

    #
    # Evolutionary mutation, by swapping two positions.
    #
    def mutate
      if top_numbers?
        i1 = (rand * (size - 9)).to_i + 9
        i2 = (rand * (size - 9)).to_i + 9
      else
        i1 = (rand * size).to_i
        i2 = (rand * size).to_i
      end

      mutant = swap(layout, i1, i2)

      if mutant.uniq.length != mutant.length
        raise "Duplicate letter from mutation!\n#{mutant.inspect}"
      end

      Layout.new(mutant, corpus)
    end

    #
    # TODO: Would be nice if this were an Array method.
    #
    def swap(a, i1, i2)
      a = a.dup
      t  = a[i1]
      a[i1] = a[i2]
      a[i2] = t
      a
    end

    #
    # Load word ranks from cache file.
    #
    def load_words(max=1000)
      return nil unless File.exist?('log/words.dat')

      a = []
      File.readlines('log/words.dat').each do |line|
        rank, word = line.strip.split(/\s+/)
        a << [word, Float(rank)]
      end

      a.sort!{ |a, b| b <=> a }

      h = {}
      a.each do |(word, rank)|
        h[word] = rank.to_f
      end
      h
    end

    #
    # Load word ranks from cache file.
    #
    def load_letters
      return nil unless File.exist?('log/letters.dat')

      h = {}
      File.readlines('log/letters.dat').each do |line|
        rank, letter = line.strip.split(/\s+/)
        h[letter] = Float(rank)
      end
      h
    end

  end

end

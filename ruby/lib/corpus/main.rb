module Corpus

  #
  #
  def self.new(directory)
    Main.new(directory)
  end

  ##
  #
  #
  class Main

    # TODO: Make customizable.
    MAX_WORDS = 50000

    #
    # 
    #
    def initialize(directory)
      raise "No such corpus directory: #{directory}" unless File.directory?(directory)

      @directory = directory

      #if cache?
      #  @analysis = Analysis.cache(directory)
      #end
    end

    ##
    ## Does the corpus have a cached analysis?
    ##
    #def cache?
    #  File.directory?(File.join(directory, '.corpus'))
    #end

    #
    # The directory which contains the text files comprising the corpus.
    #
    attr :directory

    #
    # Instance of Analysis.
    #
    def analysis
      @analysis ||= Analysis.scan(directory)
    end

    #
    # Run analysis on entire corpus.
    #
    def analyze
      @analysis = Analysis.new(directory)
      @analysis.scan
      #@analysis.save!
    end

    #
    #
    #
    def files
      analysis.files
    end

    #
    #
    #
    def words
      analysis.words
    end

    #
    #
    #
    def bigrams
      analysis.bigrams
    end

    #
    #
    #
    def letters
      analysis.letters
    end

    #
    def evolve
      require_relative 'ga'

      analysis  # prime corpus

      #population = (0..9).map do |i|
      #  Layout.random(self)
      #end

      ga = GeneticAlgorithm.new(Layout.population(self))

      1000.times do |i| 
        $stderr.print "%2s) " % [i]
        ga.evolve

        best = ga.best_fit.first
        puts best.score
        puts best
        puts
      end
    end

    #
    #
    #
    def search
      analysis  # prime corpus

      timer = Time.now
      counter = 1

      @score = 0
      @best  = nil

      loop do
        layout = Layout.random(self)
        score  = layout.score

        if score > @score
          @best  = layout
          @score = score

          puts "#{counter})"
          puts layout
          puts "Score: #{score}"
          puts "Speed: %s s" % [(Time.now - timer) / counter]
          puts
        end

        counter += 1
      end
    end

    #
    # Spelling hierarchy.
    #
    def hierarchy
      @hierarchy ||= build_hierarchy
    end

    #
    # Build the spelling hierarchy.
    #
    def build_hierarchy
      root = LetterNode.new(nil)

      # TODO: Limit word table to 50,000 highest ranking words

      words.each do |word|
        wl = root
        word.spelling.each_char do |letter|
          wl = wl.add(letter, word.count)
        end
        wl.word!(word.count)
      end

      root
    end

    #
    # Output words.
    #
    def output_words(output=$stdout)
      word_list = []

      words.each do |w|
        word_list << [words.rank(w), w.to_s]
      end

      word_list = word_list.sort_by{ |a| a.first }.reverse

      word_list.each do |(rank, word)|
        output.puts "%s %s" % [rank.to_s(' F'), word]
      end
    end

    #
    # Output bigrams.
    #
    def output_bigrams(output=$stdout)
      bigram_list = []

      bigrams.each do |b|
        bigram_list << [bigrams.rank(b), b.word1, b.word2]
      end

      bigram_list = bigram_list.sort_by{ |a| a.first }.reverse

      bigram_list.each do |(rank, w1, w2)|
        output.puts "%s %s %s" % [rank.to_s(' F'), w1, w2]
      end
    end

    #
    # Output combined table of words and bigrams.
    #
    def output_table(output=$stdout)
      word_list = words.sort_by{ |w| words.rank(w) }.reverse

      word_list = word_list[0, MAX_WORDS]

      sets = []
      word_list.each_with_index do |w, i|
        bigram_list = bigrams.matching_bigrams(w.spelling)
        bigram_list = bigram_list.sort_by{ |b| bigrams.rank(b) }.reverse
        bigram_list = bigram_list.map{ |b| b.word2 }.uniq
        bigram_list = bigram_list[0,6]  # maximum of six bigrams
        sets << [w.spelling] + bigram_list
      end

      sets.each do |w|
         output.puts(w.join(' ')) 
      end
    end

    #
    # Output the spelling hierarchy.
    #
    def output_hierarchy(output=$stdout)
      hierarchy.print_tree(output)
    end

=begin
  # Merge word list with bigram list to create an ordered
  # table of all words and their common bigrams.
  def save_table
    bigrams = {}

    bigrams_table.table.each do |w1, w2b|
      bigrams[w1] = w2b.sort_by{ |w2, b| b.probablity }.map{ |x| x[0] }.reverse
    end

    words = self.words.sort_by{ |w, r| r }.map{ |x| x[0] }.reverse
    words.uniq!

    sets = words.map do |word|
      [word] + (bigrams[word.downcase] || [])[0,6] # max 6 bigrams
    end

    File.open('table.txt', 'w') do |f|
      sets.each{ |w| f.puts(w.join(' ')) }
    end    
  end
=end

    #
    # Output letter ranks.
    # 
    def output_letters
      letters.each do |letter, freq|
        puts "%2.12f %s" % [freq, letter]
      end
    end

  end

end

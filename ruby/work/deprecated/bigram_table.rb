module Corpus

  ##
  #
  #
  class BigramTable
    include Enumerable

    #
    # Initialize BigramTable.
    #
    def initialize
      @table = Hash.new
      @index = Hash.new{ |h,k| h[k] = Hash.new }
    end

    #
    # Table is a hash.
    #
    # Returns [Hash].
    #
    attr :table

    #
    # Lookup bigrams by first word.
    #
    def [](word1)
      @index[word1]
    end

    #
    # Add a pair of word to the bigram table.
    #
    # word1 - First word. [String]
    # word2 - Second word. [String]
    # file  - The file in which the bigram was located.
    #
    # Returns nothing.
    #
    def add(word1, word2, file)
      if table.key?([word1, word2])
        bigram = table[[word1,word2]]
      else
        bigram = Bigram.new(word1, word2)
        @table[[word1,word2]] = bigram
        @index[word1][word2]  = bigram
      end
      bigram.found_in_file(file)
    end

    #
    # Tally each bigram given the total file count.
    #
    # This has to be done after all bigrams are added to ensure proper weighing.
    #
    def tally!(file_count)
      @table.each do |words, bigram|
        bigram.tally!(table.size, file_count)
      end
    end

    #
    # Size of the bigram table.
    #
    def size
      @table.size
    end

    #
    # Iterate over each bigram.
    #
    def each(&block)
      @table.values.each(&block)
    end

    #
    # Covert the word table to a hash of rank indexed by spelling.
    #
    # Returns [Hash].
    #
    def to_h
      words = {}
      @table.each do |words, bigram|
        words[words] = bigram.rank
      end
      words
    end

    #
    #
    #
    def to_a
      @table.values
    end

    #
    #
    #
    def save!(corpus)
      file = File.join(corpus, ".analysis", "bigrams.yml")

      FileUtils.mkdir_p(File.dirname(file))

      File.open(file, 'w') do |out|
         YAML.dump(self, out)
      end
    end

  end

end

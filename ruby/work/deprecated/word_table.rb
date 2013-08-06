module Corpus

  ##
  #
  #
  class WordTable
    include Enumerable

    #
    # Initialize new WordTable object.
    #
    def initialize(table={})
      @table = table
    end

    #
    # Table is a hash.
    #
    # Returns [Hash].
    #
    attr :table

    #
    #
    #
    def [](spelling)
      table[spelling] ||= Word.new(spelling)
    end

    #
    # word - [String]
    #
    def add(word, file)
      self[word].found_in_file(file)
    end

    #
    # Tally each word given the total file count.
    #
    # This has to be done after all words are added to ensure proper weighing.
    #
    def tally!(file_count)
      table.each do |spelling, word|
        word.tally!(table.size, file_count)
      end
    end

    #
    # Number of words in the table.
    #
    def size
      table.size
    end

    #
    # Iterate over each Word object in the table.
    #
    def each(&block)
      table.values.each(&block)
    end

    #
    # Covert the word table to a hash of rank indexed by spelling.
    #
    # Returns [Hash].
    #
    def to_h
      words = {}
      @table.each do |spelling, word|
        words[spelling] = word.rank
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
      file = File.join(corpus, ".analysis", "words.yml")

      FileUtils.mkdir_p(File.dirname(file))

      File.open(file, 'w') do |out|
         YAML.dump(self, out)
      end
    end

  end

end

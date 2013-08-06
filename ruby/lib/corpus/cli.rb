module Corpus

  class CLI

    #
    def self.execute!(argv=ARGV)
      new.send(*argv)
    end

    #
    def corpus(directory)
      Main.new(directory)
    end

    #
    # Analyize a corpus and save the analysis.
    #
    def analyze(directory)
      corpus(directory).analyze
    end

    # Output the letter analysis.
    def letters(directory)
      corpus(directory).output_letters
    end

    # Output the word analysis.
    def words(directory)
      corpus(directory).output_words
    end

    # Output the bigram analysis.
    def bigrams(directory)
      corpus(directory).output_bigrams
    end

    # Output the combined table of words and bigrams.
    def table(directory)
      corpus(directory).output_table
    end

    # Output the combined table of words and bigrams.
    def hierarchy(directory)
      corpus(directory).output_hierarchy
    end

    #
    #def merge(*files)
    #  Merge.run(*files)
    #end

    #
    def search(directory)
      corpus(directory).search
    end

    #
    def evolve(directory)
      corpus(directory).evolve
    end

  end

end

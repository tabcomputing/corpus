module Corpus

  ##
  # Model of a bigram and its stats.
  #
  # A bigram is a pair of words appearing together in the corpus.
  #
  class Bigram

    # First word.
    attr :word1

    # Second word.
    attr :word2

    # How many times the bigram appears in total.
    attr :count

    #
    attr :files

    #
    # Initialize new instance of Bigram.
    #
    # word1      - First word of bigram.
    # word2      - Second word of bigram.
    #
    def initialize(word1, word2)
      @word1 = word1
      @word2 = word2
      @count = 0
      @files = Hash.new(0)
    end

    #
    #
    #
    def file!(file)
      @count += 1
      @files[file] += 1
    end

    #
    #
    #
    def to_s
      "#{word1} #{word2}"
    end

  end

end

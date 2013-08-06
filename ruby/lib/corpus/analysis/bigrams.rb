module Corpus

  class Analysis

    ##
    #
    #
    class Bigrams
      include Enumerable

      #
      # Initialize Words analysis instance.
      #
      # analysis - The main Analysis instance.
      #
      def initialize(analysis)
        @analysis = analysis
      end

      #
      # The main Analysis instance.
      #
      attr :analysis

      #
      # Analysis scanner.
      #
      def scanner
        analysis.scanner
      end

      #
      # List of all bigrams from all files.
      #
      def list
        @list ||= (
          list = []      
          scanner.each_bigram do |bigram|
            list << [bigram.word1, bigram.word2]
          end
          list
        )
      end

      alias to_a list

      #
      #
      #
      def size
        scanner.bigrams.size
      end

      #
      # Iterate over each bigram as an instance of Bigram.
      #
      def each
        scanner.each_bigram do |bigram|
          yield(bigram)
        end
      end

      #
      # Total number of bigrams.
      #
      def total
        @total ||= (
          tally = 0
          scanner.each_bigram do |b|
            tally += b.count
          end
          tally
        )
      end

      #
      # Get a list of second words of bigrams matching the given
      # first word.
      #
      def matching_bigrams(word1)
        list = scanner.bigrams[word1]
        list.values
      end

      #
      # Probability of bigram's occurance in the corpus.
      #
      def probability(word1, word2=nil)
        bigram = (Bigram === word1 ? word1 : get(word1, word2))
        BigDecimal.new(bigram.count) / size
      end

      #
      # Probability of bigram's occurance in the corpus.
      #
      def file_probability(word1, word2=nil)
        bigram = (Bigram === word1 ? word1 : get(word1, word2))
        BigDecimal.new(bigram.files.size) / analysis.files.size
      end

      #
      # File weighted probablity of the bigram appearing in the corpus.
      #
      def rank(word1, word2=nil)
        weight = file_probability(word1, word2)
        weight * probability(word1, word2)
      end

      #
      #
      #
      def get(word1, word2)
        scanner.bigrams[word1][word2]
      end

    end

  end

end

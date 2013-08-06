module Corpus

  class Analysis

    ##
    #
    #
    class Words
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
      # Analysis scans.
      #
      def scanner
        analysis.scanner
      end

      #
      # List of all words from all files.
      #
      def list
        @list ||= scanner.words.keys
      end

      alias to_a list

      #
      #
      #
      def size
        scanner.words.size
      end

      #
      # Iterate over each word as an instance of Word.
      #
      def each
        scanner.words.each do |spell, word|
          yield(word)
        end
      end

      #
      # Total number of words.
      #
      def total
        @total ||= (
          tally = 0
          scanner.each_word do |w|
            tally += w.count
          end
          tally
        )
      end

      #
      # Probability of bigram's occurance in the corpus.
      #
      def probability(word)
        word = (Word === word ? word : get(word))
        BigDecimal.new(word.count) / size
      end

      #
      # Probability of word's occurance in the corpus.
      #
      def file_probability(word)
        word = (Word === word ? word : get(word))
        BigDecimal.new(word.files.size) / analysis.files.size
      end

      #
      # Weighted probablity of the word appearing in the corpus.
      #
      def rank(word)
        weight = file_probability(word)
        rank = weight * probability(word)
        rank = rank / 2 unless stem?(word)
        rank
      end

      #
      #
      #
      ENDINGS = %w{ ly er es ed ing }

      #
      #
      #
      def stem?(word)
        return false if ENDINGS.any?{ |e| word.to_s.end_with?(e) }
        return true
      end

      #
      # Get Word instance for a given word spelling.
      #
      def get(word_spelling)
        scanner.words[word_spelling]
      end

      #
      #
      #
      def to_h(max=nil)
        a = []
        scanner.each_word do |w|
          a << [w.to_s, rank(w)]
        end
        a.sort_by{ |w,r| r }.reverse
        a = a[0, max || a.size]

        h = {}
        a.each{ |w,r| h[w] = r }
        h
      end

    end

  end

end

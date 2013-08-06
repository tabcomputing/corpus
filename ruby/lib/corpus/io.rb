module Corpus

  ##
  # Read/write statisic files.
  #
  class IO

    #
    # Load words with rates. Files must be in the format of probability and
    # word on each line, e.g.
    #   
    #   0.001234053498604084 then
    #   0.001234033321248589 dog
    #   ...
    #
    # TODO: Use Log2 of probability instead of probability for rank?
    #
    # Returns hash of rank indexed by word. [Hash]
    #
    def load_words(*word_files)
      word_list = []
      word_files.each do |file|
        puts "Loading #{file}..."
        File.readlines(file).each do |line|
          rate, word = line.strip.split(/\s+/)
          word_list << [BigDecimal.new(rate), word]
        end
      end

      word_list = word_list.sort_by{ |(r, w)| r }.reverse
      word_list = word_list[0,MAX_WORDS]

      words = {}
      word_list.each do |(rate,word)|
        words[word] = rate
      end

      words
    end

  end

end

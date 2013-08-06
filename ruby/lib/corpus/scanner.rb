module Corpus

  ##
  #
  #
  class Scanner

    WORD = /[a-zA-Z']+/

    ACCEPT_WORDS   = ["a", "i"]
    REJECT_WORDS   = ["ye", "yo", "n't", "sh", "th", "ha", "ah", "la"]
    REJECT_BIGRAMS = ["ye", "yo", "n't", "sh", "th", "ha", "ah", "la"]

    ##
    ## Load from cache if it exists.
    ##
    #def self.cache(file)
    #  cache_file = File.join(File.dirname(file), '.corpus', File.basename(file) + '.yml')
    #  if File.file?(cache_file)
    #    analysis = YAML.load_file(cache_file)
    #  else
    #    analysis = new(file)
    #    analysis.run
    #    analysis.save!
    #  end
    #  analysis
    #end

    #
    # Initialize new instance of Scanner.
    #
    def initialize(files)
      @files = files

      @words   = {}
      @bigrams = Hash.new{ |h,k| h[k] = {} }

      @letters = Hash.new(0.0)
    end

    # Files to analyize.
    attr :files

    #
    attr :words

    #
    attr :bigrams

    #
    attr :letters

    #
    #
    #
    def run
      scan_words
      scan_letters
    end

    #
    # Sace file counting words and bigrams.
    #
    def scan_words
      last = nil
      #total = 0

      files.each do |file|
        #$stderr.puts "[scanning] #{file}"
        $stderr.print "."

        text = File.read(file).gsub("\n", " ")
        states = text.split(/[.,:;?!()"']\s+/)

        states.each do |state|
          state.scan(WORD) do |word|
            word = normalize(word)
            next unless word?(word)

            words[word] ||= Word.new(word)
            words[word].file!(file)

            if last && good_bigram?(word)
              bigrams[last][word] ||= Bigram.new(last, word)
              bigrams[last][word].file!(file)
            end

            last = word
          end

          last = nil
        end
      end

      $stderr.puts
    end

    #
    #
    #
    def scan_letters
      pairs = Hash.new(0.0)
      sings = Hash.new(0.0)

      last = nil
      #total = 0

      files.each do |file|
        #$stderr.puts "[scanning] #{file}"
        $stderr.print "."

        text = File.read(file).gsub("\n", " ")

        text.each_char do |letter|
          letter = letter.downcase
          if /[a-zA-Z]/ =~ letter
            pairs[last + letter] += 1 if last
            sings[letter] += 1
            last = letter
          else
            last = nil
          end
        end
      end

      total_sings = sings.values.inject(0) { |t, c| t += c }
      total_pairs = pairs.values.inject(0) { |t, c| t += c }

      sings.each do |sing, count|
        letters[sing] = (count / total_sings)
      end

      pairs.each do |pair, count|
        letters[pair] = (count / total_pairs)
      end

      $stderr.puts
    end

    #
    # Iterate over each Word.
    #
    def each_word
      @words.each do |spelling, word|
        yield(word)
      end
    end

    #
    #
    #
    def each_bigram
      @bigrams.each do |word1, rest|
        rest.each do |word2, bigram|
          yield(bigram)
        end
      end
    end

    ##
    ## Total word count.
    ##
    #def total
    #  sum = 0
    #  words.each do |word, count|
    #    sum += count
    #  end
    #  sum
    #end

    #
    # Normalize a word.
    #
    def normalize(word)
      word = word.downcase
      word = word.sub(/^-+/, '') if word.start_with?('-')
      return word
    end

    #
    # Ensure a given word is valid.
    #
    def word?(word)
      return true  if ACCEPT_WORDS.include?(word)
      return false if REJECT_WORDS.include?(word)
      return false if word.size < 2
      return false if word.size > 11
      return false if word == "n't"
      return false if word.start_with?("'")
      return false if word.end_with?("'")
      true
    end

    #
    # Check if a given word should be considered an acceptable bigram.
    #
    def good_bigram?(word)
      return false if REJECT_BIGRAMS.include?(word)
      return false if word.size < 2
      true
    end

    #
    # Save scan to cache file.
    #
    def save!
      cache_file = File.join(File.dirname(file), '.corpus', File.basename(file) + '.yml')

      FileUtils.mkdir_p(File.dirname(cache_file))

      File.open(cache_file, 'w') do |f|
        f << to_yaml
      end
    end


    ##
    ##
    ##
    #def tally
    #  word_table.tally!(@corpus_files.size)    #tally_words
    #  bigram_table.tally!(@corpus_files.size)  #tally_bigrams
    #end

    #def tally_words
      #words = {}
      #Word.list.each do |spelling, word|
      #  tally = 0
      #  words[spelling] = weighted(word.files.size) * tally  #[filing.size, tally]
      #end

      #word_total = 0
      #words.each do |w, r|
      #  word_total += r
      #end

      #@words = {}
      #words.each do |w, r|
      #  @words[w] = BigDecimal.new(r) / word_total
      #end
    #end

    #def tally_bigrams
      #bigrams = Hash.new{ |h,k| h[k] = {} }
      #bigrams_per_file.each do |w1, w2fr|
      #  w2fr.each do |w2, fr|
      #    tally = 0
      #    fr.each do |f, r|
      #      tally += r
      #    end
      #    bigrams[w1][w2] = weighted(fr.size) * tally  #[fr.size, tally]
      #  end
      #end
      #
      #bigram_total = 0
      #bigrams.each do |w1, w2r|
      #  w2r.each do |w2, r|
      #    bigram_total += r
      #  end
      #end
      #
      #@bigrams = Hash.new{ |h,k| h[k] = {} }
      #bigrams.each do |w1, w2r|
      #  w2r.each do |w2, r|
      #    @bigrams[w1][w2] = BigDecimal.new(r) / bigram_total
      #  end
      #end
    #end


    #def weighted(file_count)
    #  file_count * 0.5  # + WEIGHT) / WEIGHT
    #end

=begin
    #
    #
    #
    def save_words!
      file_name = File.basename(file)
      save_file = "log/analysis/#{file_name}.words"
      File.open(save_file, 'w') do |out|
        words.each do |word|
          out.puts("" % [word.count, word.spelling])
        end
      end
    end

    #
    #
    #
    def save_bigrams!
      file_name = File.basename(file)
      save_file = "log/analysis/#{file_name}.bigrams"
      File.open(save_file, 'w') do |out|
        bigrams.each do |bigram|
          out.puts("" % [bigram.count, bigram.word1, bigram.word2])
        end
      end
    end

    #
    #
    #
    def load!
      file = File.join(corpus, ".analysis", "words.yml")
      if File.file?(file)
        @word_table = YAML.load_file(file)
      end

      file = File.join(corpus, ".analysis", "bigrams.yml")
      if File.file?(file)
        @bigram_table = YAML.load_file(file)
      end
    end
=end

  end

end

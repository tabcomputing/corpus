module Corpus

  class Analysis

    FILES    = Dir['texts/*.txt']
    WORD     = /[a-zA-Z']+/
    WORD_MAX = 50000

    ACCEPT_WORDS   = ["a", "i"]
    REJECT_WORDS   = ["ye", "yo", "n't", "sh", "th", "ha", "ah", "la"]
    REJECT_BIGRAMS = ["ye", "yo", "n't", "sh", "th", "ha", "ah", "la"]

    def self.run!
      ca = new
      ca.run
    end

    def initialize(*corpus_files)
      @corpus_files = corpus_files
      @last  = nil
      #@total = 0
      @word_table   = WordTable.new
      @bigram_table = BigramTable.new

      #@root = LetterNode.new(nil)
    end

    attr :word_table
    attr :bigram_table

    #
    def run
      analyze
      tally
      build_hierarchy
      save
    end

    #
    def corpus_files
      FILES
    end

    #
    def analyze
      words   = Hash.new{ |h,k| h[k] = Hash.new(0) }
      bigrams = Hash.new{ |h,k| h[k] = Hash.new{ |h2,k2| h2[k2] = Hash.new(0) } }

      last    = nil
      #total   = 0

      corpus_files.each do |file|
        puts file
        text = File.read(file)
        text = text.gsub("\n", " ")
        states = text.split(/[.,:;?!]\s+/)

        states.each do |state|
          state.scan(WORD) do |word|
            word = normalize(word)
            next unless word?(word)

            word_table.add(word, file)             #words[word][file] += 1

            if last && good_bigram?(word)
              bigram_table.add(last, word, file)   #bigrams[last][word][file] += 1 if last
            end

            last = word
          end
          last = nil
        end
      end

      #@words_per_file   = words
      #@bigrams_per_file = bigrams
    end

    def tally
      word_table.tally!    #tally_words
      bigram_table.tally!  #tally_bigrams
    end

    #
    #
    #
    def build_hierarchy
      root = LetterNode.new(nil)

      # TODO: Limit word table to 50,000 whighest ranking words

      word_table.each do |word|
        wl = root
        word.spelling.each_char do |letter|
          wl = wl.add(letter, word.count)
        end
        wl.word!(word.count)
      end

      @root = root
    end

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

    def save
      save_words
      save_bigrams
      save_table
      save_heirarchy
    end

    def save_words
      word_list = []
      word_table.each do |w|
        word_list << [w.rank, w.spelling]
      end
      word_list = word_list.sort_by{ |a| a.first }.reverse

      File.open("words.txt" , "w") do |f|
        word_list.each do |(rank, word)|
          f.puts "%s %s" % [rank.to_s(' F'), word]
        end
      end
    end

    def save_bigrams
      bigram_list = []
      bigram_table.each do |b|
        bigram_list << [b.rank, b.word1, b.word2]
      end
      bigram_list = bigram_list.sort_by{ |a| a.first }.reverse

      File.open("bigrams.txt" , "w") do |f|
        bigram_list.each do |(rank, w1, w2)|
          f.puts "%s %s %s" % [rank.to_s(' F'), w1, w2]
        end
      end
    end

    #
    #
    def save_table
      words = word_table.sort_by{ |w| w.rank }.reverse

      sets = words.map do |w|
        bigrams = bigram_table[w.spelling].values
        bigrams = bigrams.sort_by{ |b| b.rank }.reverse
        bigrams = bigrams[0,6]  # maximum of six bigrams
        [w.spelling] + bigrams.map{ |b| b.word2 }
      end

      File.open('table.txt', 'w') do |f|
        sets.each{ |w| f.puts(w.join(' ')) }
      end    
    end

    #
    #
    def save_heirarchy
      File.open('heirarchy.txt', 'w') do |f|
        @root.print_tree(f)
      end    
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

    def normalize(word)
      word = word.downcase
      word = word.sub(/^-+/, '') if word.start_with?('-')
      return word
    end

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

    def good_bigram?(word)
      return false if REJECT_BIGRAMS.include?(word)
      return false if word.size < 2
      true
    end

    #def weighted(file_count)
    #  file_count * 0.5  # + WEIGHT) / WEIGHT
    #end

  end

end

#CorpusAnalysis.run!

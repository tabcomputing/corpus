# Taphonic Support Scripts
# Copyright 2012 Tab Computing
#
# These rake scripts are here to help produce a suitable list of
# words in order of their requency of general use along with their 
# most common colocates (words that occur after them). This list
# is then used for the word prediction engine.
#
# Currentyl is rather simplistic, and a number of things could be
# doen to improve it signifficantly, including have a large set 
# of words to work with (currently we have about 5,000, whereas 
# 20,000 would probably be optimal), and certain colocates we 
# could do without, e.g. "the". But we will improve on this over
# time.

require 'bigdecimal'
#require 'yaml'

module Corpus

  MAX_WORDS = 30000

  #
  # The words.txt file must contain a list of words, one on each line, in order of frequency.
  #
  # The bigrams.txt file must contain a list of words, where each line begins
  # with the main word followed by its colocate given in order of frequency.
  #
  # The result is a new file, list.txt, that has a list of words from words.txt
  # followed by their colocates.
  #
  class Merge

    #
    def self.words!(*files)
      new.run(*files)
    end

    #
    def initialize
    end

    attr :words
    attr :bigrams

    #
    def run
      word_files   = Dir['resources/mycorpus/words.txt']
      bigram_files = Dir['resources/mycorpus/bigrams.txt', 'resources/wordfreq/bigrams.txt']

      load_words(word_files)
      load_bigrams(bigram_files)

      save
      #save_hierarchy
    end

    #
    # Load words with rates. Files must be in the format of probability and
    # word on each line, e.g.
    #   
    #   0.001234053498604084 then
    #   0.001234033321248589 dog
    #   ...
    #
    def load_words(word_files)
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

      @words = words
    end

    #
    # Load bigrams with rates. Files must be in the format of probability and
    # both words on each line, e.g.
    #   
    #   0.001234053498604084 then he
    #   0.001234033321248589 dog sat
    #   ...
    #
    def load_bigrams(bigram_files)
      bigram_rates = Hash.new{ |h,k| h[k] = {} }
      bigram_files.each do |file|
        puts "Loading #{file}..."
        File.readlines(file).each do |line|
          rate, word1, word2 = line.strip.split(/\s+/)
          bigram_rates[word1][word2] ||= []
          bigram_rates[word1][word2] << BigDecimal.new(rate)
        end
      end

      bigrams = Hash.new{ |h,k| h[k] = {} }
      bigram_rates.each do |word1, bw|
        bw.each do |word2, rates|
          bigrams[word1][word2] = rates.inject(0){ |s, r| s = s + r; s } / rates.size
        end
      end

      @bigrams = bigrams

      #bglist.each do |word1, scores|
      #  bigrams[word1] = scores.sort_by{ |w, r| r }.map{ |x| x[0] }.reverse
      #end
    end

    #
    # Merge word list with bigram list to create an ordered
    # table of all words and their common bigrams.
    #
    def save
      words = self.words.keys.sort #words.sort_by{ |w, r| w }.map{ |x| x[0] } #.reverse
      words = words.uniq

      bigrams = {}
      self.bigrams.each do |w1, w2r|
        bigrams[w1] = w2r.sort_by{ |w2, r| r }.map{ |x| x[0] }.reverse
      end

      sets = words.map do |word|
        list = [word] + (bigrams[word.downcase] || [])
        list = list.uniq[0,7]  # max 6 bigrams per word
        rate = Math.log10(self.words[word]) + 10
        [rate] + list
      end

      File.open('table.txt', 'w') do |f|
        sets.each{ |w| f.puts(w.join(' ')) }
      end    
    end

    #
    #
    #
    def word_hierarchy
      root = WordLetter.new(nil)

      self.words.each do |spell, rate|
        wl = root
        spell.each_char do |c|
          wl = wl.add(c, rate)
        end
        wl.word!(rate)
      end

      return root
    end

    #
    #
    #
    def save_hierarchy
      word_hierarchy.print_tree
    end

  end

  #
  class WordLetter
    attr :letter
    attr :rate
    attr :rank
    attr :children

    def initialize(letter, rate=0)
      @letter   = letter
      @rate     = rate
      @rank     = 0
      @children = {}
    end

    def [](letter)
      @children[letter]
    end

    def add(letter, rate)
      if @children.key?(letter)
        child = @children[letter]
      else
        child = WordLetter.new(letter, rate)
        @children[letter] = child
      end
      child.rank!
      @rate = rate if rate > @rate
      child
    end

    def word!(rate)
      @children['='] = WordLetter.new('=', rate)
      @rate = rate if rate > @rate
    end

    def rank!
      @rank += 1
    end

    def print_tree(indent=0)
      if letter
        print (" " * indent)
        puts "%s %s %i"  % [letter, Math.log10(rate), rank]  #.to_s(' F')]
        indent = indent + 2
      end
      sorted = children.values.sort_by{ |wl| wl.rate }.reverse
      sorted.each do |wl|
        wl.print_tree(indent)
      end
    end

  end

end

#Corpus::Merge.run!

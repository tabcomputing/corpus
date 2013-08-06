module Corpus

  ##
  # The Analysis class manages a complete corpus scan.
  #
  class Analysis

    #
    # Load analysis from a cache.
    #
    #def self.cache(corpus_directory)
    #  analysis = new(corpus_directory)
    #  analysis.load!
    #  analysis    
    #end

    #
    #
    #
    def self.scan(directory)
      analysis = new(directory)
      analysis.scan
      analysis    
    end

    #
    # Initialize new Analysis instance.
    #
    # corpus - Directory in which text files reside.
    #
    def initialize(directory)
      raise unless File.directory?(directory)
      @directory = directory
    end

    #
    # Directory containing .txt files.
    #
    attr :directory

    #
    # Scans of each file. [Hash]
    #
    attr :scanner

    #
    # Run a scan on each file.
    #
    def scan
      @scanner = Scanner.new(files)
      @scanner.run
    end

    #
    # List of corpus text files.
    #
    def files
      @files ||= Dir[File.join(directory, '*.txt')]
    end

    #
    def words
      @words ||= Words.new(self)
    end

    #
    def bigrams
      @bigrams ||= Bigrams.new(self)
    end

    #
    def letters
      @letters ||= @scanner.letters
    end

    #
    # Get Word instance.
    #
    def word(word)
      words.get(word)
    end

    #
    # Get Bigram instance.
    #
    def bigram(word1, word2)
      bigrams.get(word1, word2)
    end

    ##
    ## Load scans.
    ##
    #def load!
    #  files.each do |file|
    #    $stderr.puts "Load: #{file}"
    #    scans[file] = Scanner.cache(file)
    #  end
    #end

    ##
    ## Save scans.
    ##
    #def save!
    #  scans.each do |file, scan|
    #    scan.save!
    #  end
    #end

  end

end

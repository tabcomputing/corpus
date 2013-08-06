module Corpus

  #
  # LetterNode is used to create a hierarchy of letters where
  # each branch forms a word.
  #
  class LetterNode
    attr_reader :letter
    attr_reader :count
    attr_reader :children

    def initialize(letter, count=0)
      @letter   = letter
      @count    = count
      @children = {}
    end

    def [](letter)
      @children[letter]
    end

    def add(letter, count)
      if @children.key?(letter)
        child = @children[letter]
      else
        child = LetterNode.new(letter)
        @children[letter] = child
      end
      child.increase(count)
      child
    end

    def word!(count)
      @children['='] = LetterNode.new('=', count)
    end

    def increase(count)
      @count += count
    end

    def print_tree(output=$stdout, indent=0)
      if letter
        output.print (" " * indent)
        output.puts "%s %i"  % [letter, count]  #.to_s(' F')]
        indent = indent + 2
      end
      sorted = children.values.sort_by{ |wl| wl.count }.reverse
      sorted.each do |wl|
        wl.print_tree(output, indent)
      end
    end

  end

end

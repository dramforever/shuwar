module Shuwar

  ##
  # The tokenizer
  class Tokenizer


    ##
    # Make a new tokenizer that reads input from +f+
    #
    # +f+ should respond to +each_line+
    def initialize(f)
      @input = f
      @stack = []
    end

    ##
    # Just a helper to chomp the line before +each_line+ing
    def each_input_line(&block)
      @input.each_line {|l| block.call l.chomp }
    end

    ##
    # Iterates through each line and yield tokens. You should call this
    def each_token(&block)
      each_input_line do |line|
        each_token_in_line line, &block
      end

      alter_stack [], &block
    end

    ##
    # Tokenize one line
    def each_token_in_line(line, &block)
      sp = line.split "|", 2
      if sp.size != 2
        alter_stack [], &block
        for c in %w{[ ] #}
          line.replace line.gsub c, " #{c} "
        end
        tags = line.split
        tags.each &:strip!
        tags.reject! &:empty?
        tags.each do |t|
          case
            when t == "["
              block.call OpenParen.new
            when t == "]"
              block.call CloseParen.new
            when t == "#"
              block.call Quote.new
            when t == "nil"
              block.call nil
            when t.chars.all? {|c| ('1'..'9') === c }
              block.call t.to_i
            when t.chars.all? {|c| ('1'..'9') === c or c == '.' }
              block.call t.to_f
            when /\A[a-zA-Z]\z/ =~ t[0] && t.chars.all? {|c| /\A[a-zA-Z0-9_]+\z/ =~ c }
              block.call t.to_sym
            else
              raise "#{t}? What was that?"
          end
        end
      else
        ts, txt = sp
        tags = ts.split ":"
        tags.each &:strip!
        tags.reject! &:empty?
        alter_stack tags, &block
        block.call txt.strip
      end
    end

    ##
    # Change stack to the specified contents by yielding an open paren and
    # a symbol when push is needed and yielding a close paren when pop is
    # needed.
    #
    # Make sure you call +alter_stack [], block+ before you go
    def alter_stack(to, &block)
      stack_tail, to_tail = @stack.dup, to.dup

      begin
        while stack_tail.fetch(0) == to_tail.fetch(0)
          stack_tail.shift
          to_tail.shift
        end
      rescue
        # No more items in one tail. End it.
      end

      stack_tail.size.times do
        block.call CloseParen.new
        @stack.pop
      end

      to_tail.each do |t|
        @stack.push t
        block.call OpenParen.new
        block.call t.to_sym
      end
    end

    ##
    # The base token class. We use these to distinguish them.
    class Token
      alias_method :inspect, :to_s

      def eql?(other)
        to_s == other.to_s
      end

      alias_method :==, :eql?
    end

    ##
    # Just opening paren
    class OpenParen < Token
      def to_s
        "["
      end

      alias_method :inspect, :to_s
    end

    ##
    # Just closing paren
    class CloseParen < Token
      def to_s
        "]"
      end

      alias_method :inspect, :to_s
    end

    ##
    # Just quote
    class Quote < Token
      def to_s
        "#"
      end

      alias_method :inspect, :to_s
    end
  end
end

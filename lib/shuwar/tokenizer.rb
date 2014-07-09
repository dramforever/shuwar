module Shuwar
  class Tokenizer
    def initialize(f)
      @input = f
      @stack = []
    end

    def each_input_line(&block)
      @input.each_line {|l| block.call l.chomp }
    end

    def each_token(&block)
      each_input_line do |line|
        each_token_in_line line, &block
      end

      alter_stack [], &block
    end

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

    class Token
      alias_method :inspect, :to_s

      def eql?(other)
        to_s == other.to_s
      end

      alias_method :==, :eql?
    end

    class OpenParen < Token
      def to_s
        "["
      end

      alias_method :inspect, :to_s
    end

    class CloseParen < Token
      def to_s
        "]"
      end

      alias_method :inspect, :to_s
    end

    class Quote < Token
      def to_s
        "#"
      end

      alias_method :inspect, :to_s
    end
  end
end

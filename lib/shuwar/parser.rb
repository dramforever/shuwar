require "shuwar/tokenizer"

module Shuwar
  class Parser
    def initialize(tok)
      @enum = tok.enum_for :each_token
    end

    def get_object
      case @enum.peek
        when Tokenizer::OpenParen
          @enum.next # Eat OpenParen
          tmp = []
          until @enum.peek.is_a? Tokenizer::CloseParen
            tmp.push get_object
          end
          @enum.next # Eat CloseParen
          tmp
        when Tokenizer::Quote
          @enum.next # Eat Quote
          [:quote, get_object]
        when Tokenizer::CloseParen
          raise "Got some close paren here. Why?"
        else
          @enum.next
      end
    end

    def input_end?
      begin
        @enum.peek
        false
      rescue StopIteration
        true
      end
    end

    def each_object!
      until input_end?
        yield get_object
      end
    end

    def each_object(&block)
      if block
        each_object! &block
      else
        enum_for :each_object!
      end
    end
  end
end
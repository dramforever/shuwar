raise "No requiring smoke_test, please" unless __FILE__ == $0

require "shuwar"
require "pp"

module Shuwar
  class SmokeTest
    def initialize(input)
      @input = input
    end

    def test_tokenizer
      tk = Shuwar::Tokenizer.new @input
      counter = 0
      tk.each_token do |t|
        case t
          when Shuwar::Tokenizer::OpenParen
            puts "    " * counter + t.inspect
            counter += 1
          when Shuwar::Tokenizer::CloseParen
            counter -= 1
            puts "    " * counter + t.inspect
          when Shuwar::Tokenizer::Quote
            puts "    " * counter + t.inspect
          else
            puts "    " * counter + t.inspect
        end
      end
    end

    def test_parser
      tk = Shuwar::Tokenizer.new @input
      parser = Shuwar::Parser.new tk

      parser.each_object do |x|
        pp x
        puts
      end
    end

    def test_runtime
      tk = Shuwar::Tokenizer.new @input
      parser = Shuwar::Parser.new tk
      runtime = Shuwar::Runtime.new

      parser.each_object do |x|
        runtime.evaluate x
      end
    end
    def test_all
      puts "========== [The input     ] =========="
      puts @input

      puts "========== [Test Tokenizer] =========="
      test_tokenizer

      puts "========== [Test Parser   ] =========="
      test_parser

      puts "========== [Test Runtime  ] =========="
      test_runtime
    end
  end
end

Shuwar::SmokeTest.new(<<END).test_all
[set a 1]

[ [lambda [val]
    [print val]
    [puts val]
  ]

  a
]

puts | Text
puts | More Text

puts | Another puts
END
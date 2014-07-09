require "rspec"
require "shuwar"

describe Shuwar::Tokenizer do
  def ts(text)
    Shuwar::Tokenizer.new(text).enum_for(:each_token).to_a
  end

  def op; Shuwar::Tokenizer::OpenParen.new; end
  def cp; Shuwar::Tokenizer::CloseParen.new; end
  def quote; Shuwar::Tokenizer::Quote.new; end

  it %q{should handle lists} do
    expect(ts "[a b]").to eq [op, :a, :b, cp]
  end

  it %q{should handle quotes} do
    expect(ts "#a").to eq [quote, :a]
  end

  it %q{should handle oneline text without tags} do
    expect(ts "| text").to eq ["text"]
  end

  it %q{should handle oneline text with tags} do
    expect(ts "a:b | t").to eq [op, :a, op, :b, "t", cp, cp]
  end

  it %q{should handle opening and closing tags well} do
    expect(ts <<END).to eq [op, :a ,"x", "y", op, :b, "z", cp, "w", cp]
a   | x
a   | y
a:b | z
a   | w
END
  end
end
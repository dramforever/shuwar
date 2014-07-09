require "rspec"
require "shuwar"

describe Shuwar::Parser do
  def parse(tokens)
    tokens.define_singleton_method :each_token do |&block|
      each &block
    end

    Shuwar::Parser.new(tokens).each_object.to_a
  end

  def op; Shuwar::Tokenizer::OpenParen.new; end
  def cp; Shuwar::Tokenizer::CloseParen.new; end
  def quote; Shuwar::Tokenizer::Quote.new; end

  it "should be able to handle one token" do
    expect(parse [:a]).to eq [:a]
    expect(parse [1] ).to eq [1]
  end

  it "should be able to handle one level lists" do
    expect(parse [op, :a, cp]).to eq [[:a]]
  end

  it "should be able to handle nested lists" do
    expect(parse [op, :a, op, :a, cp, :a, cp]).to eq [[:a, [:a], :a]]
  end

  it "should be able to handle multiple objects" do
    expect(parse [:a, :b]).to eq [:a, :b]
  end
end
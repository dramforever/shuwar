require 'rspec'

describe Shuwar::Runtime do
  def rt; Shuwar::Runtime.new; end

  def run(obj)
    rt.evaluate obj
  end

  it "should handle literals" do
    expect(run 1).to eq 1
  end

  it "should handle symbols" do
    expect(run :load).not_to be_nil
  end

  it "should handle lambdas" do
    expect(run [:lambda, [:a, :b], :a, :b]).not_to be_nil
  end

  it "should handle set" do
    a = rt
    a.evaluate [:set, :a, 1]
    expect(a.evaluate :a).to eq 1
  end

  it "should be able to do lexical scoping" do
    a = rt
    a.evaluate [:set, :a, 1]
    a.evaluate [:set, :b, [:lambda, [], [:set, :a, 2]]]
    a.evaluate [:b]
    expect(a.evaluate :a).to eq 1
  end
end
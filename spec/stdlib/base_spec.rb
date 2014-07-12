require "rspec"
require "shuwar"

describe Shuwar::Stdlib::Base do
  def rt; Shuwar::Runtime.new; end

  def run(obj)
    rt.evaluate obj
  end

  it "has a working load" do
    run [:load, [:quote, :nokogiri]]
  end

  it "has a working begin" do
    expect(run [:begin, 1, 2]).to eq 2
  end

  it "has a working print" do
    run [:print, 1]
  end

  it "has a working puts" do
    run [:puts, 1]
  end

  # Marcos seems to have been tested in runtime_spec
end
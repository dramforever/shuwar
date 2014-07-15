require "rspec"
require "shuwar"

describe Shuwar::Stdlib::Base do
  def rt; Shuwar::Runtime.new; end

  def run(obj)
    rt.evaluate obj
  end

  it "should have a working load" do
    run [:load, [:quote, :nokogiri]]
  end

  it "should have a working begin" do
    expect(run [:begin, 1, 2]).to eq 2
  end

  it "should have a working print" do
    run [:print, 1]
  end

  it "should have a working puts" do
    run [:puts, 1]
  end

  it "should have a working load_file" do
    run [:load_file, "sample.swr"]
  end

  it "should have a working fetch" do
    r = rt
    expect(run [:fetch, r, [:quote, :load]]).not_to be_nil
  end

  it "should have a working import" do
    r = rt
    r.evaluate [:import, :sample]
    expect(r.evaluate :sample).not_to be_nil

    r.evaluate [:import, :sample, :main_content]
    expect(r.evaluate :main_content).not_to be_nil
  end

  # Other marcos seems to have been tested in runtime_spec
end
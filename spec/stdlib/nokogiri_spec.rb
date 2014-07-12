require "rspec"
require "shuwar"

describe Shuwar::Stdlib::Nokogiri do
  def rt
    a = Shuwar::Runtime.new
    a.load_lib :nokogiri
    a
  end

  def run(obj)
    rt.evaluate obj
  end

  it "should produce correct HtmlTag values" do
    # This does not actually test that it's created correctly!
    expect(run [:div,
                   [:quote,
                       [[:class, "test those classes"],
                       [:id, "test_id"]] ],

                "assxsasx"]

    ).to be_a Shuwar::Stdlib::Nokogiri::HtmlTag
  end

  it "should produce html" do
    run [:put_html, "aaa"]
    run [:put_html, [:div, [], "aaa"]]
  end
end
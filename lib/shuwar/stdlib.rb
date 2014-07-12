module Shuwar
  module Stdlib
    autoload :Base, "shuwar/stdlib/base"
    autoload :Nokogiri, "shuwar/stdlib/nokogiri"

    LIST = {
      base: :Base,
      nokogiri: :Nokogiri
    }

    def self.load(name)
      l = const_get(LIST[name])
      [l.const_get(:VALUES), l.const_get(:MARCOS)]
    end
  end
end
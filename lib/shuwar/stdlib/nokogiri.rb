begin
  gem "nokogiri", "~> 1.6"
rescue Gem::LoadError
  raise "Cannot find gem nokogiri ~> 1.6. Make sure you have it installed"
end

require "nokogiri"

module Shuwar::Stdlib
  module Nokogiri
    MARCOS = {}

    class HtmlTag
      def initialize(name, attrs, *children)
        @name = name.to_s
        @attrs = attrs.to_h
        @children = children
      end

      def add_to(a)
        doc = a.document
        ele = doc.create_element @name, @attrs
        @children.each do |c|
          case c
            when String then ele << c
            else c.add_to ele
          end
        end
        doc << ele
      end
    end

    def self.tagger(name)
      lambda {|attrs = {}, *children| HtmlTag.new name, attrs, *children}
    end

    VALUES = {
        put_html: lambda do |ele|
          doc = ::Nokogiri::HTML::Document.new
          case ele
            when HtmlTag then ele.add_to doc
            else doc << ele
          end
          puts doc.to_html
        end,

        html_tagger: lambda {|name| tagger name}
    }

    %w{div span p pre code}.each do |t|
      VALUES[t.to_sym] = tagger t.to_sym
    end

  end
end
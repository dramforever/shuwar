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
        ele = a.document.create_element @name, @attrs
        @children.each do |c|
          case c
            when String then ele << c
            else c.add_to ele
          end
        end
      end
    end

    def self.tagger(name)
      lambda do |*args|
        case args[0]
          when Array then HtmlTag.new name, args[0], *args[1..-1]
          else HtmlTag.new name, {}, *args
        end
      end
    end

    def self.add_tagger(name)
      VALUES[name] = tagger name
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

    %w{div span p pre code html body head}.each do |t|
      add_tagger t.to_sym
    end

    (1..6).each do |i|
      add_tagger "h#{i}".to_sym
    end
  end
end
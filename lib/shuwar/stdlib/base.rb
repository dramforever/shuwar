require "shuwar/stdlib"

module Shuwar::Stdlib
  module Base
    VALUES = {
        load: lambda do |lib|
          load_lib lib
        end,

        some_tag: lambda do |*texts|
          "SOME ( #{ texts.join "\n" } ) TAG"
        end,

        p: lambda do |*texts|
          "<p>#{ texts.join "\n" }</p>"
        end,

        begin: lambda do |*vals|
          vals[-1]
        end,

        print: lambda do |*vals|
          vals.each {|a| p a}
        end,

        puts: lambda do |*vals|
          puts *vals
        end
    }

    MARCOS = {
        quote: lambda do |val|
          val
        end,

        set: lambda do |key, val|
          set_value key, evaluate(val)
        end,

        lambda: lambda do |args, *body|
          if body.one?
            env = self # Avoiding self trouble
            lambda do |*as|
              raise "Expecting #{args.size} args, got #{as.size}" unless as.size == args.size
              e = env.dup
              (0...as.size).each do |i|
                env.set_value args[i], as[i]
              end

              e.evaluate body[0]
            end
          else
            evaluate [:lambda, args, [:begin, *body]]
          end
        end
    }
  end
end
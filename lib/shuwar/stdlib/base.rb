require "shuwar"

module Shuwar::Stdlib
  module Base
    VALUES = {
        load: lambda do |lib|
          load_lib lib
        end,

        begin: lambda do |*vals|
          vals[-1]
        end,

        print: lambda do |*vals|
          vals.each {|a| p a}
        end,

        puts: lambda do |*vals|
          puts *vals
        end,

        load_file: lambda do |name|
          File.open name do |f|
            tk = Shuwar::Tokenizer.new f
            parser = Shuwar::Parser.new tk
            runtime = Shuwar::Runtime.new

            parser.each_object do |x|
              runtime.evaluate x
            end

            runtime
          end
        end,

        fetch: lambda do |env, key|
          env.get_value key
        end,

        from_file: lambda do |name, key|
          env = evaluate [:load_file, name]
          env.get_value key
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
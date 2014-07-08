module Shuwar
  class Runtime
    attr_accessor :value_table, :marco_table

    def initialize(from = nil)
      case from
        when Shuwar::Runtime
          @value_table = from.value_table.dup
          @marco_table = from.marco_table.dup
        when nil
          @value_table = Shuwar::Runtime::DEFAULT_VALUES
          @marco_table = Shuwar::Runtime::DEFAULT_MARCOS
        else
          raise "Wrong type of arg for initialize"
      end
    end

    def set_value(key, val)
      raise "Why set value to a non-symbol?" unless key.is_a? Symbol
      @value_table[key] = val
    end

    def get_value(key)
      raise "Why reference a non-symbol?" unless key
      @value_table[key]
    end

    def has_value?(key)
      @value_table.has_key? key
    end

    def new_func(key, &block)
      raise "There's already a function #{key}" if @value_table.has_key? key
      set_value(key, block)
    end

    def new_marco(key, &block)
      raise "There's already a marco #{key}" if @marco_table.has_key? key
      raise "Why set value to a non-symbol?" unless key.is_a? Symbol
      @marco_table[key] = block
    end

    def call_marco(key, *args)
      self.instance_exec *args, &@marco_table[key]
    end

    def has_marco?(key)
      @marco_table.has_key? key
    end

    def evaluate(x)
      case x
        when Array
          if x.empty?
            nil
          elsif has_marco? x[0]
            call_marco *x
          else
            lambda{|f,*as| self.instance_exec *as, &f}.call *x.map{|a| evaluate a }
          end
        when Symbol
          get_value x
        else x
      end
    end

    DEFAULT_VALUES = {
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
    DEFAULT_MARCOS = {
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
require "shuwar/stdlib"

module Shuwar
  class Runtime
    attr_accessor :value_table, :marco_table

    def initialize
      @value_table = {}
      @marco_table = {}
      @loaded_libs = []
      load_lib :base
    end

    def dup
      a = super
      a.value_table = a.value_table.dup
      a.marco_table = a.marco_table.dup
      a
    end

    def load_lib(name)
      return if @loaded_libs.include? name
      @loaded_libs.push name
      vs, ms = Shuwar::Stdlib.load name
      @value_table.merge! vs
      @marco_table.merge! ms
    end

    def set_value(key, val)
      raise "Why set value to a non-symbol?" unless key.is_a? Symbol
      @value_table[key] = val
    end

    def get_value(key)
      raise "Why reference a non-symbol?" unless key
      raise "No value for #{key}" unless has_value? key
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
  end
end

module Supa
  class Command
    def initialize(representer:, context:, tree:, name:, options: {}, &block)
      @representer = representer
      @context = context
      @tree = tree
      @name = name
      @options = options
      @block = block
    end

    def represent
      raise NotImplementedError
    end

    private

    attr_reader :representer, :context, :tree, :name, :options, :block

    def apply_modifier(value)
      with_modifier? ? representer.send(modifier, value) : value
    end

    def modifier
      options[:modifier]
    end

    def with_modifier?
      !options[:modifier].nil?
    end

    def static_value
      getter
    end

    def dynamic_value
      if exec_on_object?
        value_from_object
      else
        value_from_representer
      end
    end

    def exec_on_object?
      options[:exec_context] != :representer
    end

    def value_from_object
      return context[getter] if context.is_a?(Hash)
      return context.send(getter) if context.respond_to?(getter)
    end

    def value_from_representer
      representer.send(getter)
    end

    def getter
      options[:getter] || name
    end

    def render_collection?
      Array(value).any? || @options[:render_empty]
    end

    def render_element?
      context || @options[:render_empty]
    end

    # Should be defined in the commands either as `dynamic_value` or `static_value`
    def value
      raise NotImplementedError
    end

    def processed_value
      apply_modifier(value)
    end
  end
end

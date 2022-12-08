# frozen_string_literal: true

module TypedParameters
  class Rule
    def initialize(schema:, controller: nil)
      @controller = controller
      @schema     = schema
      @visited    = []
    end

    def call(...) = raise NotImplementedError

    private

    attr_reader :controller,
                :visited,
                :schema

    def visited?(param) = visited.include?(param)

    def depth_first_map(param, &)
      return if param.nil?

      return if
        visited?(param)

      # Traverse down the param tree until we hit the end of a "branch",
      # then start validating in from there, moving from the outside in.
      # This is kind of like a depth first search.
      if param.schema.children&.any?
        case param.schema.children
        when Array
          if param.schema.indexed?
            param.schema.children.each_with_index { |v, i| self.class.new(schema: v, controller:).call(param[i], &) }
          else
            param.value.each { |v| self.class.new(schema: param.schema.children.first, controller:).call(v, &) }
          end
        when Hash
          param.schema.children.each { |k, v| self.class.new(schema: v, controller:).call(param[k], &) }
        end
      end

      yield param

      visited << param

      param
    end
  end
end
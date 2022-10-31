# frozen_string_literal: true

module TypedParameters
  module Types
    register(
      type: :time,
      scalar: false,
      coerce: -> v { v.to_s.match?(/\A\d+\z/) ? Time.at(v.to_i) : v.to_time },
      match: -> v { v.is_a?(Time) },
    )
  end
end

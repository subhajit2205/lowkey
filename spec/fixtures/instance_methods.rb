# frozen_string_literal: true

module Lowkey
  class InstanceMethods
    def method
      'goodbye'
    end

    def method_with_arg(goodbye)
      goodbye
    end
  end
end

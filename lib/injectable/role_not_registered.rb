module Injectable
  class RoleNotRegistered < StandardError
    def initialize(role)
      @role = role
    end

    def message
      "No class registered to perform #{@role}"
    end
  end
end

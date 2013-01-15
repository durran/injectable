# encoding: utf-8
module Injectable
  module Registerable

    # Register that instances of klass will perform the given role in this
    # container context.
    #
    # @example Register that the user_finder role will be performed by
    #   instances of DatabaseUserFinder
    #   container.register_implementation(:user_finder, DatabaseUserFinder)
    #
    # @param [ Symbol ] name The name of the role.
    # @param [ Class ] klass The name of the class performing this role.
    #
    # @since 0.0.1
    def register_implementation(name, klass)
      implementations[name] = klass
    end

    private

    def implementations
      @implementations ||= {}
    end
  end
end

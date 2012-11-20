# encoding: utf-8
module Injectable

  # The registry keeps track of all objects and their dependencies that need
  # to be injected at construction.
  #
  # @since 0.0.0
  module Registry
    extend self

    # Add a constructor method signature to the registry.
    #
    # @example Add a signature.
    #   Injectable::Registry.add(UserService, [ :user, :user_finder ])
    #
    # @param [ Class ] klass The class to set the constructor signature for.
    # @param [ Array<Symbol> ] dependencies The dependencies of the
    #   constructor.
    #
    # @since 0.0.0
    def add(klass, dependencies)
      signatures[klass] = dependencies.map { |name| name.to_s.classify.constantize }
    end

    # Get the constructor method signature for the provided class.
    #
    # @example Get the constructor signature.
    #   Injectable::Registry.signature(UserService)
    #
    # @param [ Class ] klass The class to get the signature for.
    #
    # @return [ Array<Class> ] The constructor signature.
    #
    # @since 0.0.0
    def signature(klass)
      signatures[klass]
    end

    private

    def signatures
      @signatures ||= {}
    end
  end
end

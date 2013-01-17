# encoding: utf-8
require "injectable/registerable"

module Injectable

  # The registry keeps track of all objects and their dependencies that need
  # to be injected at construction.
  #
  # @since 0.0.0
  module Registry
    include Registerable
    extend self

    # Get an implementation for the provided name.
    #
    # @example Get an implementation.
    #   Injectable::Registry.implementation(:persistable)
    #
    # @param [ Symbol ] name The name of the implementation.
    #
    # @return [ Class ] The implementing class.
    #
    # @since 0.0.2
    def implementation(name)
      impl = implementations[name]
      raise(NotRegistered.new(name)) unless impl && !impl.empty?
      impl
    end

    # Add a constructor method signature to the registry.
    #
    # @example Add a signature.
    #   Injectable::Registry.register_signature(
    #     UserService, [ :user, :user_finder ]
    #   )
    #
    # @param [ Class ] klass The class to set the constructor signature for.
    # @param [ Array<Symbol> ] dependencies The dependencies of the
    #   constructor.
    #
    # @since 0.0.0
    def register_signature(klass, dependencies)
      signatures[klass] = dependencies.map { |name| name }
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

    # This error is raised when asking for an implementing class that is not
    # registered in the registry.
    #
    # @since 0.0.2
    class NotRegistered < Exception

      # @attribute [r] name The name of the requested implementation.
      attr_reader :name

      # Initialize the new error.
      #
      # @example Initialize the error.
      #   NotRegistered.new(:persistable)
      #
      # @param [ Symbol ] name The name of the implementation.
      #
      # @since 0.0.2
      def initialize(name)
        @name = name
        super("No implementation registered for name: #{name.inspect}.")
      end
    end

    private

    def signatures
      @signatures ||= {}
    end
  end
end

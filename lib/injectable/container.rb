# encoding: utf-8
require "injectable/registerable"

module Injectable

  # A simple container that can resolve dependencies.
  #
  # @since 0.0.0
  class Container
    include Registerable

    # Get an instance of an object from the container with the provided class.
    #
    # @example Get an instance of an object for class UserService.
    #   container.get(:user_service)
    #
    # @param [ Symbol ] name the role which the returned object should perform.
    #
    # @return [ Object ] The instantiated object.
    #
    # @raise [ Injectable::RoleNotRegistered ] if queried for a role which is not
    #   registered
    #
    # @since 0.0.0
    def get(name)
      klass = implementation(name)
      if instantiated_objects.has_key?(klass)
        instantiated_objects[klass]
      else
        instantiated_objects[klass] = instantiate(klass)
      end
    end

    # Create a new container with the objects needed to resolve dependencies
    # and create new objects.
    #
    # @example Create the new container.
    #   Injectable::Container.new(user, user_finder)
    #
    # @param [ Array<Object> ] objects The dependencies.
    #
    # @since 0.0.0
    def initialize(*objects)
      objects.each do |object|
        instantiated_objects[object.class] = object
      end
    end

    # This error is raised when asking for an object out of the container that
    # cannot be resolved.
    #
    # @since 0.0.4
    class Unresolvable < Exception

      # @attribute [r] klass The klass that was attempted to instantiate.
      attr_reader :klass

      # Initialize the new error.
      #
      # @example Initialize the error.
      #   Unresolvable.new(Persistable)
      #
      # @param [ Class ] klass The class that was attempted to instantiate.
      #
      # @since 0.0.4
      def initialize(klass)
        @klass = klass
        super(
          "Could not instantiate an object for #{klass}. " +
          "Please ensure all required dependencies are in the container."
        )
      end
    end

    private

    def dependencies(klass)
      (Registry.signature(klass) || []).map do |dependency|
        get(dependency)
      end
    end

    def implementation(name)
      implementations[name] || Registry.implementation(name)
    end

    def instantiate(klass)
      begin
        klass.new(*dependencies(klass))
      rescue ArgumentError
        raise Unresolvable.new(klass)
      end
    end

    def instantiated_objects
      @instantiated_objects ||= {}
    end
  end
end

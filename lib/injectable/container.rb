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
      classes = registered_implementations(name)
      if klass = instantiated_class(classes)
        instantiated_objects[klass]
      else
        object = instantiate(classes)
        instantiated_objects[object.class] = object
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

    # Put objects into the container. Can be a single or multiple instances.
    #
    # @example Put an object in the container.
    #   container.put(user)
    #
    # @example Put multiple objects in the container.
    #   container.put(user, user_finder)
    #
    # @param [ *Object ] objects The objects to put in the container.
    #
    # @return [ Injectable::Container ] The container itself.
    #
    # @since 0.0.0
    def put(*objects)
      objects.flatten.each do |object|
        instantiated_objects[object.class] = object
      end and self
    end

    # This error is raised when asking for an object out of the container that
    # cannot be resolved.
    #
    # @since 0.0.4
    class Unresolvable < Exception

      # @attribute [r] classes The classes that were attempted to instantiate.
      attr_reader :classes

      # Initialize the new error.
      #
      # @example Initialize the error.
      #   Unresolvable.new([ Persistable, Saveable ])
      #
      # @param [ Array<Class> ] classes The classes that were attempted to
      #   instantiate with.
      #
      # @since 0.0.4
      def initialize(classes)
        @classes = classes
        super(
          "Could not instantiate an object for any of: #{classes.join(", ")}. " +
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

    def registered_implementations(name)
      implementations[name] || Registry.implementation(name)
    end

    def instantiate(classes)
      classes.each do |klass|
        begin
          return klass.new(*dependencies(klass))
        rescue ArgumentError; end
      end
      raise Unresolvable.new(classes)
    end

    def instantiated_objects
      @instantiated_objects ||= {}
    end

    def instantiated_class(classes)
      classes.detect do |klass|
        instantiated_objects[klass]
      end
    end
  end
end

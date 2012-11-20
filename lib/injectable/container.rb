# encoding: utf-8
module Injectable

  # A simple container that can resolve dependencies.
  #
  # @since 0.0.0
  class Container

    # Get an instance of an object from the container with the provided class.
    #
    # @example Get an instance of an object for class UserService.
    #   container.get(UserService)
    #
    # @param [ Class ] klass The type of the object to return.
    #
    # @return [ Object ] The instantiated object.
    #
    # @since 0.0.0
    def get(klass)
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

    private

    def dependencies(klass)
      Registry.signature(klass).map do |dependency|
        get(dependency)
      end
    end

    def instantiate(klass)
      klass.new(*dependencies(klass))
    end

    def instantiated_objects
      @instantiated_objects ||= {}
    end
  end
end

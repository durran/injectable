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
    # @param [ Symbol ] role the role which the returned object should perform.
    #
    # @return [ Object ] The instantiated object.
    #
    # @raise [ Injectable::RoleNotRegistered ] if queried for a role which is not
    #                                          registered
    #
    # @since 0.0.0
    def get(role)
      klass = implementing_class_for(role)
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

    # Register that instances of klass will perform the given role in this
    # container context.
    #
    # @example Register that the user_finder role will be performed by
    # instances of DatabaseUserFinder
    #   container.register(:user_finder, DatabaseUserFinder)
    #
    # @param [ Symbol ] role The name of the role.
    # @param [ Class ] klass The name of the class performing this role.
    #
    # @since 0.0.1
    def register(role, klass)
      implementing_classes[role] = klass
    end

    private

    def dependencies(klass)
      (Registry.signature(klass) || []).map do |dependency|
        get(dependency)
      end
    end

    def instantiate(klass)
      klass.new(*dependencies(klass))
    end

    def instantiated_objects
      @instantiated_objects ||= {}
    end

    def implementing_classes
      @implementing_classes ||= {}
    end

    def implementing_class_for(role)
      klass = implementing_classes[role]
      if klass.nil? && Object.const_defined?(role.to_s.classify)
        klass = role.to_s.classify.constantize
      end
      raise Injectable::RoleNotRegistered.new(role) if klass.nil?
      klass
    end
  end
end

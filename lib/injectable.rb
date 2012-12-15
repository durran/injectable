# encoding: utf-8
require "injectable/container"
require "injectable/inflector"
require "injectable/macros"
require "injectable/registry"

# Objects that include Injectable can have their dependencies satisfied by the
# container, and removes some basic boilerplate code of creating basic
# constructors that set instance variables on the class. Constructor injection
# is the only available option here.
#
# @since 0.0.0
module Injectable

  class << self

    # Configure the global injectable registry. Simply just yields to the
    # registry itself. If no block is provided returns the registry.
    #
    # @example Configure the registry.
    #   Injectable.configure do |registry|
    #     registry.register_implementation(:user, User)
    #   end
    #
    # @return [ Injectable::Registry ] The registry.
    #
    # @since 0.0.3
    def configure
      block_given? ? yield(Registry) : Registry
    end

    # Including the Injectable module will extend the class with the necessary
    # macros.
    #
    # @example Include the module.
    #   class UserService
    #     include Injectable
    #   end
    #
    # @param [ Class ] klass The including class.
    #
    # @since 0.0.0
    def included(klass)
      Registry.register_implementation(
        Inflector.underscore(klass.name).to_sym,
        klass
      )
      klass.extend(Macros)
    end
  end
end

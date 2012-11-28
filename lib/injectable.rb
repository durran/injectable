# encoding: utf-8
require "active_support/inflector"
require "injectable/container"
require "injectable/macros"
require "injectable/registry"
require "injectable/role_not_registered"

# Objects that include Injectable can have their dependencies satisfied by the
# container, and removes some basic boilerplate code of creating basic
# constructors that set instance variables on the class. Constructor injection
# is the only available option here.
#
# @since 0.0.0
module Injectable

  class << self

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
      klass.extend(Macros)
    end
  end
end

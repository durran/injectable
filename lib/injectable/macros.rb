# encoding: utf-8
module Injectable

  # Provides class level macros for setting up dependencies.
  #
  # @since 0.0.0
  module Macros

    # Sets up the dependencies for the class.
    #
    # @example Define a UserService that has two dependencies.
    #   class User; end
    #   class UserFinder; end
    #
    #   class UserService
    #     include Injectable
    #     dependencies :user, :user_finder
    #   end
    #
    # @note A constructor will get created for the object that takes the same
    #   number or arguments as provided to the dependencies macro. The types
    #   of these arguments must match the "classified" name of the provided
    #   symbol. For example :user would be a User class, :user_finder would be
    #   a UserFinder class. Order matters.
    #
    # @param [ Array<Symbol> ] injectables The dependency list.
    #
    # @since 0.0.0
    def dependencies(*injectables)
      define_constructor(*injectables)
      define_readers(*injectables)
      Registry.register_signature(self, injectables)
    end

    private

    def define_constructor(*injectables)
      names = names(*injectables)
      class_eval <<-CONST
        def initialize(#{names})
          #{ivars(*injectables)} = #{names}
        end
      CONST
    end

    def define_readers(*injectables)
      injectables.each do |dependency|
        attr_reader(dependency)
      end
    end

    def ivars(*injectables)
      injectables.map { |name| "@#{name}" }.join(",")
    end

    def names(*injectables)
      injectables.join(",")
    end
  end
end

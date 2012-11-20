# encoding: utf-8
module Injectable
  module Macros

    def dependencies(*injectables)
      define_constructor(*injectables)
      define_readers(*injectables)
      Registry.add(self, injectables)
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

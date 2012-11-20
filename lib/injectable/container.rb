# encoding: utf-8
module Injectable
  class Container

    def get(klass)
      if instantiated_objects.has_key?(klass)
        instantiated_objects[klass]
      else
        instantiated_objects[klass] = instantiate(klass)
      end
    end

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

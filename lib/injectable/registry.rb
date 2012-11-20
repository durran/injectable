# encoding: utf-8
module Injectable
  module Registry
    extend self

    def add(klass, dependencies)
      signatures[klass] = dependencies.map { |name| name.to_s.classify.constantize }
    end

    def signature(klass)
      signatures[klass]
    end

    def signatures
      @signatures ||= {}
    end
  end
end

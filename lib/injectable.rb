# encoding: utf-8
require "active_support/inflector"
require "injectable/container"
require "injectable/macros"
require "injectable/registry"

module Injectable

  class << self

    def included(object)
      object.extend(Macros)
    end
  end
end

# encoding: utf-8
require "injectable/macros"

module Injectable

  class << self

    def included(object)
      object.extend(Macros)
    end
  end
end

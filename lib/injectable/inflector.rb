# encoding: utf-8
module Injectable

  # Used so we don't need active support around to perform inflections.
  #
  # @since 0.0.4
  module Inflector

    class << self

      # Underscore a string. This is partially taken from Active Support, but
      # dumbed down for our purposes - we don't handle namespacing.
      #
      # @example Underscore a string.
      #   Inflector.underscore("Band")
      #
      # @param [ String ] string The string to underscore.
      #
      # @since 0.0.4
      #
      # @return [ String ] The underscored string.
      def underscore(string)
        value = string.dup
        value.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
        value.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
        value.downcase!
      end
    end
  end
end

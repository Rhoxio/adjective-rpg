module Adjective
  class Schema
    class Vulnerable
      def attributes
<<RUBY
  # Vulnerable Attributes
  t.integer :hitpoints
  t.integer :max_hitpoints
RUBY
      end
    end
  end
end
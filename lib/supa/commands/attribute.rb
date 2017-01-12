require 'supa/command'

module Supa
  module Commands
    class Attribute < Supa::Command
      def represent
        tree[name] = dynamic_value
      end
    end
  end
end

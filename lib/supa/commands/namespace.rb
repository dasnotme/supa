require 'supa/command'

module Supa
  module Commands
    class Namespace < Supa::Command
      def represent
        tree[name] = {}

        Supa::Builder.new(representer: representer, context: context, tree: tree[name]).instance_exec(&block)
      end
    end
  end
end

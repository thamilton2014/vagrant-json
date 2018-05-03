module VagrantPlugins
  module VagrantJson
    module Config
      attr_accessor :directory

      def initialize
        @directory = ".vagrant_config"
      end

    end
  end
end
module VagrantPlugins
  module VagrantJson
    module Config
      class Json < Vagrant.plugin("2", :config)
        attr_accessor :directory

        def initialize
          @directory = UNSET_VALUE
        end

        def finalize!
          if @directory == UNSET_VALUE
            @directory = ".vagrant_config"
          end
        end

        def validate(machine)
          { "json" => _detected_errors }
        end

      end
    end
  end
end
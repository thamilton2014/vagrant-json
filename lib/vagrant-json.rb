require 'vagrant-json/version'
require 'vagrant-json/plugin'
require 'active_support/core_ext/hash'

module VagrantPlugins
  module VagrantJson

    def self.source_root
      @source_root ||= Pathname.new(File.expand_path '../../', __FILE__)
    end

    def self.apply_settings(vm, yml)
      yml.each do |key0, value0|
        if !value0.is_a?(Hash) # If it's a setting,
          vm.send("#{key0}=".to_sym, value0) # we set it directly.
        else # Otherwise,
          method_object = vm.method("#{key0}".to_sym) # we're invoking a method
          value0.each do |key1, value1| # and each setting
            method_object.call("#{key1}".to_sym, value1) # needs to be passed to the method.
          end
        end
      end
    end

    def self.up!(config)
      require 'json'
      require 'yaml'

      vms = []

      files = Dir.glob("*.{json,yaml,yml}").map {|f| JSON.parse(YAML.load_file(f).to_json, symbolize_names: true)}

      files.each do |file|
        if file[:boxes]
          vms.concat(file[:boxes])
        else
          vms << file
        end
      end

      vms.each do |vm|
        config.vm.define "#{vm[:hostname]}" do |vm_config|
          apply_settings(vm_config.vm, vm)
        end
      end

    end

    I18n.load_path << File.expand_path('locales/en.yml', source_root)
    I18n.reload!

  end
end
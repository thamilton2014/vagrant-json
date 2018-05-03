# lib/vagrant-yml/plugin.rb
require "vagrant"

module VagrantPlugins
  module VagrantJson
    class Plugin < Vagrant.plugin('2')

      name 'VagrantJson'
      description "The `json` command gives you a starting point for json configurations"

      config(:json) do
        require_relative "config/json"
        Config::Json
      end

      command("json") do
        require File.expand_path("../command/root", __FILE__)
        Command::Root
      end

    end # end Plugin
  end # => end VagrantYml
end # => end
# lib/vagrant-json/command/init.rb
module VagrantPlugins
  module VagrantJson
    module Command
      class Init < Vagrant.plugin("2", :command)

        def execute
          options = {}

          opts = OptionParser.new do |o|
            o.separator "Usage: vagrant json init [options] <name, url, or path>"
            o.separator ""
            o.separator "Options:"
            o.separator ""

            o.on("-f", "--force", "Overwrite existing yml and Vagrantfile") do |n|
              options[:force] = n
            end

            o.on("-r", "--remove", "Remove existing yml and Vagrantfile") do |n|
              options[:remove] = n
            end
          end

          argv = parse_options(opts)
          return if !argv
          # if argv.empty? || argv.length > 2
          #   raise Vagrant::Errors::CLIInvalidUsage,
          #         help: opts.help.chomp
          # end

          create_vagrantfile
          create_directories
          create_vm_yaml("app01")
          create_vm_yaml("db01")
          create_default_yaml(argv[0], argv[1])

          @env.ui.info(I18n.t(
              "vagrant.plugins.yml.commands.init.success",
              avail_dir:   'available.d',
              enabled_dir: 'enabled.d',
              local_dir:   'local.d'
          ), :prefix => false)
          # Success, exit status 0
          0
        end

        def create_vagrantfile
          save_path = @env.cwd.join("Vagrantfile")
          raise Exception if save_path.exist?

          template_path = VagrantJson.source_root.join("templates/Vagrantfile")
          contents      = Vagrant::Util::TemplateRenderer.render(template_path)
          save_path.open("w+") do |f|
            f.write(contents)
          end
        end

        def create_directories
          Dir.mkdir(".vagrant_config")
        end

        def create_default_yaml(box_name = nil, box_url = nil)
          save_path = @env.cwd.join("default.yml")
          raise Exception if save_path.exist?

          template_path = VagrantJson.source_root.join("templates/default.yml")
          contents      = Vagrant::Util::TemplateRenderer.render(template_path,
                                                                 :box_name => box_name,
                                                                 :box_url  => box_url)
          save_path.open("w+") do |f|
            f.write(contents)
          end
        end

        def create_vm_yaml(vm_name, box_name: "ubuntu/xenial64")
          save_path = @env.cwd.join(".vagrant_config/#{vm_name}.yml")
          raise Exception if save_path.exist?

          template_path = VagrantJson.source_root.join("templates/local.yml")
          contents = Vagrant::Util::TemplateRenderer.render(template_path,
                                                            :host_name => "#{vm_name}.vagrant.local",
                                                            :box_name => box_name)

          save_path.open("w+") do |f|
            f.write(contents)
          end
        end

      end # => end Init
    end # => end Command
  end # => end VagrantYml
end # => end VagrantPlugins
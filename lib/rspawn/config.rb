module Rspawn
  class Config

    def initialize(root, key, cli_options)
      @root = root
      @key = key
      @cli_options = cli_options
    end

    def config_path
      "#{@root}/#{@key}/config.yml"
    end

    def config_dir
      File.dirname(config_path)
    end

    def load
      File.exist?(config_path) ? JSON.parse(File.read(config_path)) : {}
    end

    def save(option, command)
      FileUtils.mkdir_p(config_dir)
      output = option.to_h
      output[:command] = command || output[:command]
      File.write(config_path, output.to_json)
    end

    def remove
      FileUtils.rm_rf(config_dir)
    end

    def option(command = nil)
      option = {}
      save_option = load
      option[:working_dir] = @cli_options['working_dir'] || save_option['working_dir'] || Dir.pwd
      FileUtils.mkdir_p(option[:working_dir])
      Dir::chdir(option[:working_dir])

      option[:log_file] = @cli_options['log_file'] || save_option['log_file'] || config_dir + '/' + @key + '.log'
      option[:pid_file] = @cli_options['pid_file'] || save_option['pid_file'] || config_dir + '/' + @key + '.pid'
      option[:timeout] = @cli_options['timeout'] || save_option['timeout'] || 10
      option[:processes] = @cli_options['processes'] || save_option['processes'] || 1
      command = command || save_option['command']
      return option, command
    end

  end
end

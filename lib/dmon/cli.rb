require 'thor'
require 'json'

module Dmon
  class CLI < Thor

    include Thor::Actions

    class_option :root, type: :string, default: ENV['HOME'] + '/.dmon', desc: 'dmon root'
    class_option :processes, aliases: '-p', type: :numeric, default: nil, desc: 'command'
    class_option :working_dir, type: :string, default: nil, desc: 'command'
    class_option :log_file, type: :string, default: nil, desc: 'command'
    class_option :pid_file, type: :string, default: nil, desc: 'pid_file'
    class_option :timeout, type: :numeric, default: nil, desc: 'timeout'
    class_option :tail, type: :boolean, default: false, desc: 'sync_log'

    def initialize(args = [], options = {}, config = {})
      super(args, options, config)
      @class_options = config[:shell].base.options
      @config = get_config(args.first)
    end

    desc "start", "start daemon"
    option :command, aliases: '-c', type: :string, default: nil, desc: 'command'
    def start(key)
      start_action(options['command'], 'start')
    end

    desc "restart", "restart daemon"
    option :command, aliases: '-c', type: :string, default: nil, desc: 'command'
    def restart(key)
      start_action(options['command'], 'restart')
    end

    desc "stop", "stop daemon"
    def stop(key)
      option, command = @config.option
      DmonWorker.spawn!(option, ["stop"])
    end

    desc "status", "staus check daemon"
    def status(key = nil)
      keys = key.nil? ? Dir.glob(@class_options['root'] + "/*") : [key]
      keys = keys.map { |file| File.basename(file) }
      keys.each do |proc_name|
        option, command = get_config(proc_name).option
        puts "#{proc_name}:"
        puts "command: #{command}"
        puts "#{option}"
        DmonWorker.spawn!(option, ["status"])
        puts
      end
    end

    desc 'remove', 'remove'
    def rm(key)
      @config.remove
    end

    desc 'tail', 'remove'
    def tail(key)
      option, command = @config.option(nil)
      tail_log(option[:log_file])
    end

    desc 'version', 'show version'
    def version
      puts VERSION
    end

    private
    def start_action(command, action)
      option, command = @config.option(command)
      @config.save(option, command)
      DmonWorker.spawn!(option, [action, command])
      tail_log(option[:log_file]) if @class_options['tail']
    end

    def tail_log(log_file)
      sleep 1
      system("tail -F #{log_file}*")        
    rescue Exception => e
    end

    def get_config(key)
      Config.new(@class_options['root'], key, @class_options)
    end
  end
end

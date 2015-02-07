require 'daemon_spawn'

module Dmon
  class DmonWorker < DaemonSpawn::Base
    def start(args)
      command = args.first
      ENV['DAEMON_RB_INDEX'] = "#{@index}"
      exec(command)
    rescue Exception => e
      puts "error"
    end

    def stop
    end

  end
end


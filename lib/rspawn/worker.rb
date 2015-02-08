require 'daemon_spawn'

module Rspawn
  class RspawnWorker < DaemonSpawn::Base
    def start(args)
      command = args.first
      ENV['RSPAWN_INDEX'] = "#{@index}"
      exec(command)
    rescue Exception => e
      puts "error"
    end

    def stop
    end

  end
end


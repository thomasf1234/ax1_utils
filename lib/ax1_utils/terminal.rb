module Ax1Utils
  class Terminal
    include Lock
    EXIT_STATUS_SUCCESS = 0
    DEFAULT_TIMEOUT_SECONDS = 30*60

    attr_reader :history

    def initialize
      @history = []
    end

    def exec(command, timeout=DEFAULT_TIMEOUT_SECONDS)
      lock do
        begin
          before_exec(command)
          return_value = sh(command, timeout)
          exit_status = last_exit_status
          raise ShellException.new(exit_status, command) unless exit_status.exitstatus == EXIT_STATUS_SUCCESS
          return_value
        rescue Exception => e
          on_exception(command, e)
        ensure
          @history << command
          after_exec(command)
        end
      end
    end

    def log_exec(command, output_path)
      exec("#{command} >> #{output_path} 2>&1")
    end

    def silent_exec(command)
      exec("#{command} > /dev/null")
    end

    def ssh_command(username, host, port, command, options={})
      options = ssh_options(port).merge(options)
      "ssh #{format_options(options)} #{username}@#{host} \"#{command}\""
    end

    def scp_command(username, host, port, source, destination, options={})
      options = ssh_options(port).merge(options)
      "scp #{format_options(options)} #{source} #{username}@#{host}:#{destination}"
    end

    protected
    def before_exec(command)
      #this hook is called prior to executing a command line call
    end

    def after_exec(command)
      #this hook is called after executing a command line call
    end

    def on_exception(command, exception)
      #this hook is called on error executing a command line call
    end

    def ssh_options(port)
      { 'LogLevel' => 'quiet', 'UserKnownHostsFile' => '/dev/null', 'StrictHostKeyChecking' => 'no', 'NumberOfPasswordPrompts' => 0, 'Port' => port }
    end

    def format_options(hash)
      hash.map {|name,value| "-o #{name}=\"#{value}\"" }.join(' ')
    end

    def last_exit_status
      $?
    end

    def sh(command, timeout)
      Timeout::timeout(timeout) do
        `#{command}`
      end
    end
  end
end
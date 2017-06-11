module Ax1Utils
  class ShellException < RuntimeError
    attr_reader :pid, :exitstatus, :command

    def initialize(exit_status, command)
      super("#{exit_status.inspect} for '#{command}'")
      @pid = exit_status.pid
      @exitstatus = exit_status.exitstatus
      @command = command
    end
  end
end
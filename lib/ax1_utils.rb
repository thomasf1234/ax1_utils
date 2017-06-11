require 'date'

module Ax1Utils
  VERSION = '0.0.1'

  def self.average(array)
    array.inject{ |sum, el| sum + el }.to_f / array.count
  end

  def self.system2(command)
    success = system(command)
    raise "An error occurred executing command: #{command}" unless success
  end

  def self.timestamp
    DateTime.now.utc.strftime("%Y%m%d%H%M%S")
  end
end

require_relative 'ax1_utils/exceptions/shell_exception'

require_relative 'ax1_utils/lock'
require_relative 'ax1_utils/retry'
require_relative 'ax1_utils/prompt'
require_relative 'ax1_utils/stopwatch'
require_relative 'ax1_utils/terminal'
require_relative 'ax1_utils/s_logger'


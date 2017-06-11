require 'logger'
require 'singleton'

module Ax1Utils
  class SLogger
    COLOUR_CODES = {
        red: 31,
        green: 32,
        yellow: 33,
    }
    LOG_DIR = 'log'

    include Singleton
    include Lock

    def self.finalize(id)
      instance.close_files
    end

    def initialize
      ensure_log_dir
      ObjectSpace.define_finalizer(self, self.class.method(:finalize).to_proc)
      @loggers = {}
    end

    def close_files
      @loggers.values.each(&:close)
    end

    def fatal(name, message)
      lock do
        logger(name).fatal(colorize(message, :red))
      end
    end

    def error(name, message)
      lock do
        logger(name).error(colorize(message, :red))
      end
    end

    def warn(name, message)
      lock do
        logger(name).warn(colorize(message, :yellow))
      end
    end

    def info(name, message)
      lock do
        logger(name).info(message)
      end
    end

    def debug(name, message)
      lock do
        logger(name).debug(message)
      end
    end

    def success(name, message)
      lock do
        logger(name).info(colorize(message, :green))
      end
    end

    def clear(name)
      lock do
        logger(name).clear
      end
    end

    def file_path(name)
      lock do
        logger(name).file_path
      end
    end

    private
    def ensure_log_dir
      Dir.mkdir(LOG_DIR) unless Dir.exist?(LOG_DIR)
    end

    def logger(name)
      if @loggers.has_key?(name)
        @loggers[name]
      else
        @loggers[name] = CustomLogger.new(name)
      end
    end

    def colorize(string, colour)
      colour.nil? ? string : "\e[#{COLOUR_CODES[colour]}m#{string}\e[0m"
    end

    class CustomLogger < Logger
      attr_reader :name, :file_path

      def initialize(name)
        @name = name
        @file_path = File.expand_path(File.join("log", "#{name}.log"))
        super(@file_path)
      end

      def clear
        File.open(@file_path, 'w') do |file|
          file.truncate(0)
        end
      end
    end
  end
end
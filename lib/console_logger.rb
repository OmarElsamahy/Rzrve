# frozen_string_literal: true

require "logger"
require "active_support/broadcast_logger"
require "rainbow/refinement"
using Rainbow

class ConsoleLogger
  include Singleton

  LOG_LEVEL_COLORS = {
    DEBUG: :chocolate,
    INFO: :green,
    WARN: :yellow,
    ERROR: :red,
    FATAL: :red
  }

  DATE_TIME_FORMAT = "%Y-%m-%d %H:%M:%S %z"

  def initialize
    Rainbow.enabled = true
    stdout_logger = build_logger($stdout)
    env_file_logger = build_logger("#{Rails.root.join("log/#{Rails.env}.log")}")
    @logger ||= ActiveSupport::BroadcastLogger.new(stdout_logger, env_file_logger)
    set_log_level(Rails.application.config.log_level.to_s.downcase)
  end

  def set_log_level(log_level)
    case log_level.downcase
    when "debug"
      @logger.level = Logger::DEBUG
    when "info"
      @logger.level = Logger::INFO
    when "warn"
      @logger.level = Logger::WARN
    when "error"
      @logger.level = Logger::ERROR
    when "fatal"
      @logger.level = Logger::FATAL
    end
  end

  attr_reader :logger

  def log_with_current_severity(message)
    @logger.add(@logger.level, message)
  end

  private

  def build_logger(output)
    logger = Logger.new(output)
    logger.formatter = proc do |severity, datetime, progname, msg|
      Rainbow("  [#{datetime.strftime(DATE_TIME_FORMAT)} ##{Process.pid}] #{severity} -- : #{msg}\n").send(LOG_LEVEL_COLORS[severity.to_sym])
    end
    logger
  end
end

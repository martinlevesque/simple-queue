class Logger
  @level : Int32

  LEVELS_MAPPING = {
    "DEBUG": {"int_level": 0, "std_stream": STDOUT},
    "INFO":  {"int_level": 1, "std_stream": STDOUT},
    "ERROR": {"int_level": 2, "std_stream": STDERR},
  }

  def initialize(level : String)
    @human_level = level

    @level = LEVELS_MAPPING[@human_level]["int_level"]
  end

  def debug(msg : String)
    log(msg, "DEBUG")
  end

  def info(msg : String)
    log(msg, "INFO")
  end

  def error(msg : String)
    log(msg, "ERROR")
  end

  def error(msg : Nil)
  end

  private def format_log(msg : String, level : String)
    "#{Time.utc} [#{level}]: #{msg}"
  end

  private def log(msg : String, from_level : String) : String
    if LEVELS_MAPPING[from_level.upcase]["int_level"] >= @level
      logged_msg = format_log(msg, from_level)
      LEVELS_MAPPING[from_level.upcase]["std_stream"].puts logged_msg

      logged_msg
    else
      ""
    end
  end
end

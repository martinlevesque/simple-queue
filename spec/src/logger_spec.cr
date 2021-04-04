require "spec"
require "../../src/logger"

describe Logger do
  describe "#debug" do
    it "with LOG_LEVEL DEBUG" do
      logger = Logger.new("DEBUG")
      logger.debug("test").should contain("UTC [DEBUG]: test")
    end

    it "with LOG_LEVEL INFO" do
      logger = Logger.new("INFO")
      logger.debug("test").should eq("")
    end
  end

  describe "#error" do
    it "with LOG_LEVEL INFO" do
      logger = Logger.new("INFO")
      logger.error("test").should contain("UTC [ERROR]: test")
    end
  end
end

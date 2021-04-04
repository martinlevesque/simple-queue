require "spec"
require "../../src/communication"

describe Communication do
  describe "#parse_user_command" do
    it "happy path PUSH" do
      result = Communication.parse_user_command("PUSH here ...")

      expected_result = {"command" => "PUSH", "queue" => "here", "content" => "..."}
      result.should eq(expected_result)
    end

    it "happy path PUSH with spaces" do
      result = Communication.parse_user_command("PUSH here . .")

      expected_result = {"command" => "PUSH", "queue" => "here", "content" => ". ."}
      result.should eq(expected_result)
    end

    it "happy path SUBSCRIBE" do
      result = Communication.parse_user_command("SUBSCRIBE here")

      expected_result = {"command" => "SUBSCRIBE", "queue" => "here", "content" => ""}
      result.should eq(expected_result)
    end
  end
end

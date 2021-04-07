require "spec"
require "../../../src/queuing/queue_processing"
require "../../../src/queuing/queue"

describe Queuing::QueueProcessing do
  describe "#queue" do
    it "does not exist" do
      # q1 = Queuing::QueueProcessing.queue("test")
      # q1.class.should eq Queuing::Queue
      # q1.name.should eq "test"
    end

    it "does exist" do
      # q1 = Queuing::QueueProcessing.queue("test")
      # should have same ref if called with the same name
      # Queuing::QueueProcessing.queue("test").should eq q1
      # Queuing::QueueProcessing.queue("test").name.should eq "test"
    end
  end
end

require "spec"
require "../../../src/queuing/queue_processing"
require "../../../src/queuing/queue"

describe Queuing::Queue do
  storage = Queuing::QueueStorageMaker.get

  describe "#push" do
    it "happy path" do
      q = Queuing::Queue.new("test", storage)

      q.push({"content" => "hello"})

      q.len.should eq 1
    end
  end

  describe "#subscribe" do
    it "happy path" do
      q = Queuing::Queue.new("test", storage)

      c1 = TCPSocket.new
      c2 = TCPSocket.new

      q.subscribe(c1)
      q.subscribers.should eq({c1 => true})

      q.subscribe(c2)
      q.subscribers.should eq({c1 => true, c2 => true})
    end
  end

  describe "#unsubscribe" do
    it "happy path" do
      q = Queuing::Queue.new("test", storage)

      c1 = TCPSocket.new
      c2 = TCPSocket.new

      q.subscribe(c1)
      q.subscribe(c2)

      q.subscribers.should eq({c1 => true, c2 => true})

      q.unsubscribe(c2)
      q.subscribers.should eq({c1 => true})
    end
  end
end

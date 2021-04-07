require "spec"
require "../../../src/queuing/queue_storage_memory"

describe Queuing::QueueStorageMemory do
  describe "#push" do
    it "push happy path" do
      s = Queuing::QueueStorageMemory.new
      m = "hello-world"
      s.push(m)
      s.len.should eq 1

      s.push(m)
      s.len.should eq 2
    end
  end

  describe "#shift" do
    it "happy path" do
      s = Queuing::QueueStorageMemory.new
      s.push("record-1")
      s.push("record-2")
      s.push("record-3")

      s.shift.should eq("record-1")
      s.shift.should eq("record-2")
      s.shift.should eq("record-3")
      s.shift.should eq(nil)
    end
  end
end

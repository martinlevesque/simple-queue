require "./queue_storage"

module Queuing
  class QueueStorageMemory < QueueStorage
    def initialize
      @deque = Deque(String).new
    end

    def push(content : String)
      @deque.push(content)
    end

    def pop : String | Nil
      @deque.shift?
    end

    def len
      @deque.size
    end
  end
end

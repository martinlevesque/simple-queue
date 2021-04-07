require "./queue_storage"

module Queuing
  class QueueStorageMemory < QueueStorage
    def initialize
      @deque = Deque(String).new
    end

    def push(content : String)
      @deque.push(content)
      puts "push cur size -> #{@deque.size}"
    end

    def shift : String | Nil
      res = @deque.shift?
      puts "shift cur size -> #{@deque.size}"
      res
    end

    def front : String | Nil
      @deque.first
    end

    def len
      @deque.size
    end

    def to_s
      "#{@deque}"
    end
  end
end

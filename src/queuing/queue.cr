require "socket"

module Queuing
  class Queue
    getter :name

    def initialize(name : String, storage : QueueStorage)
      @name = name
      @subscribers = [] of TCPSocket
    end

    def push(command_info : Hash)
    end
  end
end

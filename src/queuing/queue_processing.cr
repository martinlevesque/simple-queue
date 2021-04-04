require "./queue"
require "./queue_storage_maker"

module Queuing
  module QueueProcessing
    @@queues = {} of String => Queue

    def self.process(command_info : Hash)
      command = command_info["command"]

      content = {
        "PUSH":        ->{ process_push(parts) },
        "SUBSCRIBE":   ->{ process_subscribe(parts) },
        "UNSUBSCRIBE": ->{ process_unsubscribe(parts) },
      }[command].call
    end

    def self.queue(name : String)
      if @@queues.has_key?(name)
        @@queues[name]
      else
        @@queues[name] = Queue.new(name, QueueStorageMaker.get)
      end
    end

    def self.process_push(command_info : Hash)
      queue(command_info["queue"]).push(command_info)
    end

    def self.process_subscribe(command_info : Hash)
    end

    def self.process_unsubscribe(command_info : Hash)
    end
  end
end

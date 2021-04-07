require "./queue"
require "./queue_storage_maker"
require "./input_command_info"

module Queuing
  class QueueProcessing
    getter :ch_input

    def initialize
      @ch_input = Channel(InputCommandInfo).new

      spawn do
        queues = Hash(String, Queue).new

        while input_command_info = @ch_input.receive
          q_name = input_command_info.command_info["queue"]

          queue = QueueProcessing.access_queue(queues, q_name)

          queue.ch_input.send(input_command_info.dup)
        end
      end
    end

    def self.access_queue(queues : Hash(String, Queue), name : String)
      if queues.has_key?(name)
        queues[name]
      else
        queues[name] = Queue.new(name, Queuing::QueueStorageMaker.get)
      end
    end
  end
end

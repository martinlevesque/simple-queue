require "socket"
require "./input_command_info"
require "../app.cr"

module Queuing
  class Queue
    getter :name, :subscribers, :ch_input, :ch_storage, :storage

    def initialize(name : String, storage : QueueStorage)
      @name = name
      @subscribers = {} of TCPSocket | Nil => Bool
      @storage = storage
      @ch_input = Channel(InputCommandInfo).new(capacity = 100000)
      @wip = false

      process_input
      generate_queue_tick
    end

    def process_input
      spawn do
        App.logger.info("Queue #{name} booting")

        while input_command = @ch_input.receive
          App.logger.debug("Queue #{name} got event - #{input_command}")
          command = input_command.command_info["command"]

          {
            "PUBLISH":     ->{ publish(input_command.dup) },
            "SUBSCRIBE":   ->{ subscribe(input_command.dup) },
            "UNSUBSCRIBE": ->{ unsubscribe(input_command.dup) },
            "HANDLE_MSG":  ->{ handle_msg(input_command.dup) },
          }[command].call
        end
      end
    end

    def generate_queue_tick
      spawn do
        loop do
          sleep 0.5

          send_process_tick
        end
      end
    end

    private def send_process_tick
      App.logger.debug("Queue #{name} tick")

      command = {
        "command" => "HANDLE_MSG",
        "queue"   => name,
        "content" => "",
      }
      @ch_input.send(Queuing::InputCommandInfo.new(nil, command))
    end

    def publish(command : InputCommandInfo)
      @storage.push(command.command_info["content"])

      # send_process_tick # unless @wip
    end

    def subscribe(command : InputCommandInfo)
      @subscribers[command.socket] = true
    end

    def unsubscribe(command : InputCommandInfo)
      @subscribers.delete command.socket
    end

    def handle_msg(command : InputCommandInfo)
      return if subscribers.empty? || @storage.len == 0
      @wip = true
      App.logger.debug("Queue #{name} will handle - #{@storage.front}")

      subscribers.keys.each do |subscriber|
        puts "command.command_info -> #{command.command_info}"
        content = @storage.front
        queue = command.command_info["queue"]
        Communication.send_back_msg(subscriber, queue, "PUBLISH", content)
      end

      puts "q before #{len}"

      @storage.shift

      delay = Time.utc - command.enqueued_at
      App.logger.info("Queue after len #{name} = #{len}, msg took #{delay}")

      send_process_tick if @storage.len > 0
    end

    def len
      @storage.len
    end
  end
end

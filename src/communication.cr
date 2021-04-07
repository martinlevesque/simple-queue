require "./queuing/queue_processing"
require "./queuing/input_command_info"

module Communication
  SEPARATOR_COMMANDS = " "

  def self.parse_user_command(message : String)
    # PUBLISH QUEUE-NAME sadf-asdf-asdf-asdf-\n
    # SUBSCRIBE QUEUE-NAME

    if message.downcase == "exit"
      raise "EXIT"
    end

    parts = message.split(SEPARATOR_COMMANDS)

    if parts.size < 2
      raise "Bad command request (#{message})"
    end

    command = parts.first.upcase

    unless ["PUBLISH", "SUBSCRIBE", "UNSUBSCRIBE"].includes?(command)
      raise "Invalid command #{command}"
    end

    queue_name = parts[1]
    content = {
      "PUBLISH":     ->{ parse_publish(parts) },
      "SUBSCRIBE":   ->{ parse_subscribe(parts) },
      "UNSUBSCRIBE": ->{ parse_unsubscribe(parts) },
    }[command].call

    {
      "command" => command,
      "queue"   => queue_name,
      "content" => content,
    }
  end

  def self.parse_publish(parts)
    parts.shift
    parts.shift

    parts.join(SEPARATOR_COMMANDS)
  end

  def self.parse_subscribe(parts)
    ""
  end

  def self.parse_unsubscribe(parts)
    ""
  end

  def self.handle_client(client : TCPSocket, queue_processor : Queuing::QueueProcessing)
    while message = client.gets
      # client.gets
      puts "stats 1 = #{GC.stats}"
      begin
        if message
          command = parse_user_command(message.dup)
          puts "stats = #{GC.stats}"

          queue_processor.ch_input.send(Queuing::InputCommandInfo.new(client, command).dup)
        end
      rescue ex
        break if ex.message == "EXIT"

        client.puts "ERROR: #{ex.message}"
        App.logger.error("#{client.remote_address}: #{ex.message}")
      end

      # GC.free(Pointer(Void).new(message.object_id))
      # GC.collect
    end

    App.logger.debug("Closing socket #{client.remote_address}")
    client.close
  end

  def self.send_back_msg(subscriber, queue, msg_type, msg)
    begin
      return if !subscriber || !subscriber.remote_address

      App.logger.debug("  Sending to #{subscriber.remote_address}")

      subscriber.send("#{msg_type}:#{queue}: #{msg}\n")
    rescue e
      App.logger.error(" - Unable to send to subscriber #{subscriber}")
    end
  end
end

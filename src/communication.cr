module Communication
  SEPARATOR_COMMANDS = " "

  def self.parse_user_command(message : String)
    # PUSH QUEUE-NAME sadf-asdf-asdf-asdf-\n
    # POP QUEUE-NAME

    if message.downcase == "exit"
      raise "EXIT"
    end

    parts = message.split(SEPARATOR_COMMANDS)

    if parts.size < 2
      raise "Bad command request"
    end

    command = parts.first.upcase

    unless ["PUSH", "SUBSCRIBE", "UNSUBSCRIBE"].includes?(command)
      raise "Invalid command #{command}"
    end

    queue_name = parts[1]
    content = {
      "PUSH":        ->{ parse_push(parts) },
      "SUBSCRIBE":   ->{ parse_subscribe(parts) },
      "UNSUBSCRIBE": ->{ parse_unsubscribe(parts) },
    }[command].call

    {
      "command" => command,
      "queue"   => queue_name,
      "content" => content,
    }
  end

  def self.parse_push(parts)
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

  def self.handle_client(client : TCPSocket)
    while message = client.gets
      begin
        if message
          command = parse_user_command(message)

          puts "to process -> #{command}"
        end
      rescue ex
        break if ex.message == "EXIT"

        client.puts "ERROR: #{ex.message}"
        App.logger.error("#{client.remote_address}: #{ex.message}")
      end
    end

    App.logger.debug("Closing socket #{client.remote_address}")
    client.close
  end
end

require "socket"

module Queuing
  class InputCommandInfo
    getter :socket, :command_info, :enqueued_at
    @command_info : Hash(String, String)

    def initialize(socket : TCPSocket | Nil, command_info : Hash)
      @socket = socket
      @command_info = command_info
      @enqueued_at = Time.utc
    end
  end
end

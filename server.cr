require "socket"
require "./src/app.cr"
require "./src/communication.cr"

PORT = 9000
HOST = "localhost"

App.logger.info("Booting on port #{HOST}:#{PORT}")

server = TCPServer.new(HOST, PORT)

while client = server.accept?
  spawn Communication.handle_client(client)
end

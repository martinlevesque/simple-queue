require "socket"
require "./src/app.cr"
require "./src/communication.cr"
require "./src/queuing/queue_processing"

PORT = 9000
HOST = "localhost"

App.logger.info("Booting on port #{HOST}:#{PORT}")

server = TCPServer.new(HOST, PORT)
queue_processor = Queuing::QueueProcessing.new

while client = server.accept?
  spawn Communication.handle_client(client, queue_processor)
end

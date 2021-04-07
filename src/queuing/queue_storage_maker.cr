require "./queue_storage_memory"

module Queuing
  module QueueStorageMaker
    def self.get : QueueStorage
      if ENV.has_key?("QUEUE_STORAGE")
        # TODO
        QueueStorageMemory.new
      else
        QueueStorageMemory.new
      end
    end
  end
end

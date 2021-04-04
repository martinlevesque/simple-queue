module Queuing
  abstract class QueueStorage
    abstract def push(content : String)
  end
end

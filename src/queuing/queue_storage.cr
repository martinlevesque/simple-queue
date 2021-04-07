module Queuing
  abstract class QueueStorage
    abstract def push(content : String)
    abstract def shift : String | Nil
    abstract def front : String | Nil
    abstract def len
  end
end

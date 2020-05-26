import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //Usage
        let notificationMessage = CustomNotificationMessage(messageToBeShared: "Testing Notification")
        let _ = Reciever(publisher: Publisher.shared, message: notificationMessage)
        // Result will be - Message Recieved is: Testing Notification
    }
}


// MessageProtocol so that only custom messages can be send throughout the system
protocol MessageProtocol {
    func message() -> String
}

class CustomNotificationMessage: MessageProtocol {
    
    private let messageToBeShared: String
    
    init(messageToBeShared: String) {
        self.messageToBeShared = messageToBeShared
    }

    func message() -> String {
        return messageToBeShared
    }
}

protocol SubscriberProtocol {
    func recieve(message: MessageProtocol)
}

protocol PublisherProtocol {
    func publish(messageInformation: String, subscriber: SubscriberProtocol)
    func get(message: MessageProtocol)
}


// Class responsible for publishing the notification
class Publisher: PublisherProtocol {
    
    static let shared = Publisher()
    private init() {}
    
    private var subscriberContainer = [String: [SubscriberProtocol]]()

    func publish(messageInformation: String, subscriber: SubscriberProtocol) {
        if var alreadyAddedInfoSubscribers = subscriberContainer[messageInformation] {
            alreadyAddedInfoSubscribers.append(subscriber)
        } else {
           subscriberContainer[messageInformation] = [subscriber]
        }
    }

    func get(message: MessageProtocol) {
        if let allSubscribers  = subscriberContainer[message.message()] {
            for subscriber in allSubscribers {
                subscriber.recieve(message: message)
            }
        }
    }
}


class Reciever: SubscriberProtocol {
    
    init(publisher: PublisherProtocol, message: MessageProtocol) {
        publisher.publish(messageInformation: message.message(), subscriber: self)
        publisher.get(message: message)
    }

    func recieve(message: MessageProtocol) {
        print("Message Recieved is:",message.message())
    }
}

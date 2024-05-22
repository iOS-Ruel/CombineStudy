import UIKit
import Combine

extension Notification.Name {
    static let newEvent = Notification.Name("new_event")
}

struct Event {
    let title: String
    let scheduledOn: Date
}





let eventPublisher = NotificationCenter
    .Publisher(center: .default, name: .newEvent, object: nil)
    .map { notification -> String? in
        return (notification.object as? Event)?.title ?? ""
    }

let theEventTitleLabel = UILabel()
let newEventLabelSubscriber = Subscribers.Assign(object: theEventTitleLabel, keyPath: \.text)


eventPublisher
    .subscribe(newEventLabelSubscriber)

let event = Event(title: "Introduction to Combine Framework", scheduledOn: Date())
NotificationCenter.default.post(name: .newEvent, object: event)

print("Recent event notified is: \(theEventTitleLabel.text!)")

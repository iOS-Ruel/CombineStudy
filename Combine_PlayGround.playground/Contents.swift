import UIKit
import Combine


var myIntArrayPublisher: Publishers.Sequence<[Int], Never> = [1,2,3].publisher

myIntArrayPublisher
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("완료")
        case .failure(let error) :
            print("실패", error.localizedDescription)
        }
    }, receiveValue: { reciveNum in
        print("값을 받음 : \(reciveNum)")
    })


var myNotification = Notification.Name("com.chung.customNotification")

var myDefaultPublisher = NotificationCenter.default.publisher(for: myNotification)

var mySubscribtion: AnyCancellable?

var mySubscribtionSet = Set<AnyCancellable>()

//mySubscribtion = myDefaultPublisher.sink(receiveCompletion: { completion in
//    switch completion {
//    case .finished:
//        print("완료")
//    case .failure(let failure):
//        print("실패", failure.localizedDescription)
//    }
//}, receiveValue: { recive in
//    print("값을 받음 : \(recive)")
//})
//
//
//mySubscribtion?.store(in: &mySubscribtionSet)

myDefaultPublisher.sink(receiveCompletion: { completion in
    switch completion {
    case .finished:
        print("완료")
    case .failure(let failure):
        print("실패", failure.localizedDescription)
    }
}, receiveValue: { recive in
    print("값을 받음 : \(recive)")
})
.store(in: &mySubscribtionSet)



NotificationCenter.default.post(Notification(name: myNotification))
NotificationCenter.default.post(Notification(name: myNotification))
NotificationCenter.default.post(Notification(name: myNotification))

//KVO
class MyFirend {
    var name = "철수" {
        didSet {
            print("name - didSet() : ", name)
        }
    }
}

var myFreind = MyFirend()
var myFirendSubscription: AnyCancellable = ["영수", "야미", "구미"].publisher
                                                .assign(to: \.name, on: myFreind)

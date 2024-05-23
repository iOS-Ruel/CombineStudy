import UIKit
import Combine


[1,2,3]
    .publisher
    .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
            print("Something went wrong: \(error)")
        case .finished :
            print("Receive Completion")
        }
    }, receiveValue: { value in
        print("Received value \(value)")
    })

import Combine
import Foundation
import PlaygroundSupport


let subscription = Timer.publish(every: 1, on: .main, in: .common)
    .autoconnect()
    .sink { output in
        print("finished stream with: \(output)")
    } receiveValue: { value in
        print("receive value: \(value)")
    }
/*
 Timer.publish() -> 일정 간격으로 현재 날자를 반복적으로 내보내는 Publisher 반환
 .autoconnect : Timer 객체가 생성되면 타이머 시작
 sink {}
    -> output : 구독이 완료되면 호출
    -> receiveValue : 값이 게시되면 호출
 
 */

//-> 타이머 실행 중 중단을 원하면 작업이 완료되었을때 구독을 취소해야함



RunLoop.main.schedule(after: .init(Date(timeIntervalSinceNow: 5))) {
    print(" - cancel subscription")
    subscription.cancel()
}

// subscription.cancel() : 타이머를 취소하고, 값 방출 중지


var subscription2: Cancellable? = Timer.publish(every: 1, on: .main, in: .common)
    .autoconnect()
    .print("data stream")
    .sink { output in
        print("finished stream with : \(output)")
    } receiveValue: { value in
        print("receive value: \(value)")
    }

RunLoop.main.schedule(after: .init(Date(timeIntervalSinceNow: 5))) {
    print(" - cancel subscription")
//    subscription.cancel()
    subscription2 = nil
}

// subscription2 = nil 이와 같이도 사용할 수 잇음
//  -> 뷰할당이 취소되고 구독이 더이상 필요없을때 구독을 취소하믄 사례
//  -> cancel()에 할당된 리소스가 해제됨.

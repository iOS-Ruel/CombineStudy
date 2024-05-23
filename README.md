# CombineStudy
Combine Playground - Combine 학습을 위한 놀이터~

---
## Subscriptions 규칙 요약
- subscriber은 하나의 subscription만 가질 수 있음
- 0개 이상의 값을 published(게시)할 수 있음
- 최대 한번의 Completion(완료)가 호출됨

  
### 구독이 완료되지 않을 수 있을까?

  - 구독이 완료되어야 하지만 항상 그런것은 아님. Notification를 보면 알 수 있음  
  ```
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
  
  /*
  let newEventLabelSubscriber = Subscribers.Assign(object: theEventTitleLabel, keyPath: \.text)
  eventPublisher
      .subscribe(newEventLabelSubscriber)
  */
  // 위와 같이 사용할 수 있고, 아래와 같이 사용 가능
  eventPublisher.assign(to: \.text, on: theEventTitleLabel)
  
  let event = Event(title: "Introduction to Combine Framework", scheduledOn: Date())
  NotificationCenter.default.post(name: .newEvent, object: event)
  
  print("Recent event notified is: \(theEventTitleLabel.text!)")
  ```
  - 0개 이상의 알림을 받지만 구독이 완료되지 않고 지속되고 있음
  - 위 코드에서 NotificationCenter를 사용한 퍼블리셔는 계속해서 알림을 받을 수 있고, 완료가 없음. 따라서 구독이 완료되지 않는 Subscription임

### Completing publisher는 무엇일까?
  - 특정 작업이 완료되거나 오류가 발생했을때 Completion(완료) 이벤트를 방출하는 publisher
  > 예를 들자면 URLSession을 통해 네트워크 요청을 하여 응답이 완료 또는 오류가 발생했을때 publisher가 완료됨


---


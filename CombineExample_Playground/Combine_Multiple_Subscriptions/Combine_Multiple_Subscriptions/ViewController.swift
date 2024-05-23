//
//  ViewController.swift
//  Combine_Multiple_Subscriptions
//
//  Created by Chung Wussup on 5/23/24.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @Published var isNextEnabled: Bool = false
    // private var switchSubscriber: AnyCancellable?
    private var subscribers = Set<AnyCancellable>() // ← set of all subscriptions
    
    @IBOutlet weak var sampleSwitch: UISwitch!
    @IBOutlet weak var sampleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Save the Cancellable Subscription
        $isNextEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: sampleButton)
            .store(in: &subscribers) // ← storing the subscription
    }
    
    @IBAction func didChangeSwitch(_ sender: UISwitch) {
        isNextEnabled = sender.isOn
    }

}

/*
 Set을 사용하여 어려 구독을 처리할 수 있음
 
 코드에서 isNextEnabled를 구독하면 subscribers Cancellable 컬렉션에 저장됨
 VC가 해제되면, 컬렉션도 해제되고 그에 속한 구독자들도 취소됨
 
 
 
 */

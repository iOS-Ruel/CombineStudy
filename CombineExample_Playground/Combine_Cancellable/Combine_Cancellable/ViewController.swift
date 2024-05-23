//
//  ViewController.swift
//  Combine_Cancellable
//
//  Created by Chung Wussup on 5/23/24.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @Published var isNextEnabled: Bool = false
    private var switchSubscriber: AnyCancellable?
    @IBOutlet private weak var acceptAgreementSwitch: UISwitch!
    @IBOutlet private weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchSubscriber = $isNextEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: nextButton)
    }
    
    @IBAction func didSwitch(_ sender: UISwitch) {
        isNextEnabled = sender.isOn
    }
}

/*
 Subscribers는 값을 수신하고 처리하려 할 때 subscription을 유지할 수 있음.
 subscription은 더 이상 필요하지 않으면 해제해야함
 
 Combine에서 메모리 관리를 위해 AnyCancellable을 사용하는데
 AnyCancellable을 사용하면 cnacel() 메서드가 호출되어 구독을 종료함
 
 이때, viewController가 해제되면(deinit) 프로퍼티들이 해제되며 cancel()메서드도 호출됨
 
 "구독을 취소하면 순환참조(retain-cycle)을 방지 할 수 있음"
 
 */

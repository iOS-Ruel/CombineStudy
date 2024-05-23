import Combine

import PlaygroundSupport
import UIKit

//@Published를 사용하여 시간에 따른 변경사항 값 바인딩

class AgreementFormVC: UIViewController {

    @Published var isNextEnabled: Bool = false
    @IBOutlet private weak var acceptAgreementSwitch: UISwitch!
    @IBOutlet private weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        $isNextEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: nextButton)
    }
    
    @IBAction func didSwitch(_ sender: UISwitch) {
        isNextEnabled = sender.isOn
    }
}

/*
 - UISwitch는 didSwitch(_ sender: UISwitch)메소드를 통해 isNextEnabled의 값을 true 또는 false로 변경
 - 변경된 값을 구독(isNextEnabled)하고 있으므로 변경이 되면 nextButton의 IsEnabled에 바인딩되어 값을 변경함
 - enabled 되는 상황은 UI가 변경되어야 하기 때문에 main 쓰레드에서 이루어져야함
    따라서 receive(on: DispatchQueue.main) 수행
    isNextEnabled 값이 변경될 때마다 이 변경 사항이 메인 큐에서 버튼의 isEnabled 프로퍼티에 반영
    메인 큐에서 작업을 수행하는 이유는 모든 UI 업데이트가 메인 큐에서 이루어져야 하기 때문. 이로 인해 UI 업데이트가 스레드 안전하게 처리
 
 
 
 */

let viewController = AgreementFormVC()
PlaygroundPage.current.liveView = viewController

//PlaygroundPage.current.needsIndefiniteExecution = true
//출처: https://greatgift.tistory.com/entry/Playground-에서-View-Controller-사용하기 [greatgift:티스토리]

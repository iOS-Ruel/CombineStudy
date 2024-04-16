//
//  ViewController.swift
//  CombinePassword
//
//  Created by Chung Wussup on 4/16/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var myButton: UIButton!
    
    
    var viewModel: MyViewModel!
    
    private var mySubscription = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MyViewModel()
        
        
        //텍스트필드에서 나가는 이벤트를 뷰모델의 프로퍼티가 구독
        passwordTextField
            .myTextPublisher
            .receive(on: DispatchQueue.main)
            //구독
            .assign(to: \.passwordInput, on: viewModel)
            .store(in: &mySubscription)
        
        passwordConfirmTextField
            .myTextPublisher
        //다른 쓰레드와 같이 작업하기 때문에 RunLoop로
            .receive(on: RunLoop.main)
            //구독
            .assign(to: \.passwordConfirmInput, on: viewModel)
            .store(in: &mySubscription)
        
        
        //버튼이 뷰모델의 퍼블리셔를 구독
        viewModel.isMatchPasswordInput
            .print()
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: myButton)
            .store(in: &mySubscription)
    }
    
    
}


extension UITextField {
    
    var myTextPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification,
                                             object: self)
        //UITextField 가져옴
        .compactMap{ $0.object as? UITextField }
        //String 가져옴
        .map { $0.text ?? ""}
        .print()
        .eraseToAnyPublisher()
    }
    
}

extension UIButton {
    var isValid: Bool {
        get {
            backgroundColor == .yellow
        }
        set {
            backgroundColor = newValue ? .yellow : .lightGray
            isEnabled = newValue
            setTitleColor(newValue ? .blue : .white, for: .normal)
        }
    }
}

//
//  MyViewModel.swift
//  CombinePassword
//
//  Created by Chung Wussup on 4/16/24.
//

import Foundation
import Combine

class MyViewModel {
        
    @Published var passwordInput: String = "" {
        didSet {
            print("myViewModedl / password Input :\(passwordInput)")
        }
    }
    @Published var passwordConfirmInput: String = "" {
        didSet {
            print("myViewModedl / password Confirm Input :\(passwordConfirmInput)")
        }
    }
    
    //들어온 퍼블리셔들의 값 일치 여부를 반환하는 퍼블리셔
    lazy var isMatchPasswordInput: AnyPublisher<Bool, Never> = Publishers
        .CombineLatest($passwordInput, $passwordConfirmInput)
        .map{ (password: String, passwordConfirm: String) in
            if password == "" || passwordConfirm == "" {
                return false
            }
            
            if password == passwordConfirm {
                return true
            } else {
                return false
            }
        }
        .print()
        .eraseToAnyPublisher()
    
}

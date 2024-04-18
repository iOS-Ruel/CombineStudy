//
//  ViewController.swift
//  CombineSearch
//
//  Created by Chung Wussup on 4/18/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .black
        searchController.searchBar.searchTextField.accessibilityIdentifier = "mySearchBarTextField"
        
        
        return searchController
    }()
    
    @IBOutlet weak var myLabel: UILabel!
    var mySubscription = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.searchController = searchController
        searchController.isActive = true
        
        searchController.searchBar.searchTextField
            .myDebounceSearchPublisher
            .sink { [weak self] recivedValue in
                guard let self = self else { return }
                
                self.myLabel.text = recivedValue
                
                print("recivedValue: \(recivedValue)")
            }
            .store(in: &mySubscription)
    }
    
    
}


extension UISearchTextField {
    var myDebounceSearchPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: self)
            //노티피케이션센터에서 UISearchTextFiedl 가져옴
            .compactMap { $0.object as? UISearchTextField }
            // 가져온 UISearchTextField에서 string 가져옴
            .map { $0.text ?? "" }
            //글자를 입력할때마다가 아닌 입력이 끝났을때 일정시간 (1초) 후 처리 입력관련이기때문에 RunLoop사용
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            //글자가 1개라도 있을때 이벤트를 보낼것
            .filter{ $0.count > 0 }
            .print()
            .eraseToAnyPublisher() // AnyPublisher로 변경
    }
}

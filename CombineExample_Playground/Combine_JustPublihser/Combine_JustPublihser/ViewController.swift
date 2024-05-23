//
//  ViewController.swift
//  Combine_JustPublihser
//
//  Created by Chung Wussup on 5/23/24.
//

import UIKit
import Combine

struct User: Codable {
    let name: String
}

class ViewController: UIViewController {
    let url = URL(string: "https://jsonplaceholder.typicode.com/users")
    var observer: AnyCancellable?
    private var users: [User] = []
    
    private let tableView: UITableView = {
       let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        
        observer = fetchUsers()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] users in
            self?.users = users
            self?.tableView.reloadData()
        })
        
        
    }
    
    
    
    func fetchUsers() -> AnyPublisher<[User], Never>{
        guard let url = url else {
            return Just([])
                .eraseToAnyPublisher()
        }
        
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [User].self, decoder: JSONDecoder())
            .catch { _ in
                //오류 발생시 빈배열 반환
                Just([])
            }
            .eraseToAnyPublisher()
        
        return publisher
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = users[indexPath.row].name
        cell.contentConfiguration = content
        
        return cell
    }
    
    
}

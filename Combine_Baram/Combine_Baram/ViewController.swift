//
//  ViewController.swift
//  Combine_Baram
//
//  Created by Chung Wussup on 6/1/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let searchTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .lightGray
        return tf
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("search", for: .normal)
        //        button.setTitleColor(.black, for: .normal)
        //        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    private lazy var serverPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let serverList: [String] = ["연", "무휼", "하자", "호동", "유리", "진"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
        fetch()
        fetchBasic(ocid: "9dafa5dc47e658339112911901c80c9e")
    }
    
    private func configureUI() {
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(serverPickerView)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 30),
            
            searchButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchButton.widthAnchor.constraint(equalToConstant: 50),
            
            serverPickerView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 10),
            serverPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            serverPickerView.widthAnchor.constraint(equalToConstant: 100),
            serverPickerView.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    
    
    
    func fetch() {
        
        let idURL = BASE_URL + "id"
        
        guard var urlComponents = URLComponents(string: idURL) else {
            print("Error: cannot create URLComponents")
            return
        }
        
        var queryItem = [URLQueryItem]()
        queryItem.append(URLQueryItem(name: "character_name", value: "즐다방"))
        queryItem.append(URLQueryItem(name: "server_name", value: "연"))
        urlComponents.queryItems = queryItem
        
        guard let requestURL = urlComponents.url else { return }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(NEXON_API_KEY, forHTTPHeaderField: "x-nxopen-api-key")
        
        
        URLSession(configuration: .default).dataTask(with: request) { data, response, error in
            if let error = error {
                print("URLSession Error \(String(describing: error.localizedDescription))")
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                
                if let data = data {
                    do {
                        let userOcid = try JSONDecoder().decode(CharacterOcid.self, from: data)
                        print(userOcid)
                        
                    } catch {
                        print("DATA Error")
                    }
                }
            }
        }
        .resume()
        
    }
    
    func fetchBasic(ocid: String) {
        let idURL = BASE_URL + "character/basic"
        
        guard var urlComponents = URLComponents(string: idURL) else {
            print("Error: cannot create URLComponents")
            return
        }
        
        var queryItem = [URLQueryItem]()
        queryItem.append(URLQueryItem(name: "ocid", value: ocid))
        urlComponents.queryItems = queryItem
        
        guard let requestURL = urlComponents.url else { return }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.setValue(NEXON_API_KEY, forHTTPHeaderField: "x-nxopen-api-key")
        
        
        URLSession(configuration: .default).dataTask(with: request) { data, response, error in
            if let error = error {
                print("URLSession Error \(String(describing: error.localizedDescription))")
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                
                if let data = data {
                    do {
                        let characterBasic = try JSONDecoder().decode(CharacterBasic.self, from: data)
                        print(characterBasic)
                    } catch {
                        print("DATA Error")
                    }
                }
            }
        }
        .resume()
    }
    
}


extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.serverList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.serverList[row]
    }
    
}

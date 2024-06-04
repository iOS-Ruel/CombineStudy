//
//  Extension_URLComponents.swift
//  CombineTest
//
//  Created by Chung Wussup on 6/2/24.
//

import Foundation


//Sample
extension URLComponents {
    
    /// URL Component
    /// - Parameters:
    ///   - path: BaseURL 이후 올 경로
    ///   - query: request Param [String: String]
    ///   - completion: 반환될 데이터 closure
    func fetchData<T: Codable>(path: String, query: [String:String], completion: @escaping(Result<T, Error>) ->Void) {
        let baseURL = "https://"
        let url = baseURL + path
        
        
        guard var components = URLComponents(string: url) else {
            print("DEBUG - URLComponent Error")
            return
        }
        
        var queryItems = [URLQueryItem]()
        query.forEach { key, value in
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        components.queryItems = queryItems
        
        guard let requestURL = components.url else { return }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.setValue("APIKey", forHTTPHeaderField: "x-nxopen-api-key")
        
        
        URLSession(configuration: .default).dataTask(with: request) { data, response, error in
            if let error = error {
                print("URLSession Error \(String(describing: error.localizedDescription))")
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                
                if let data = data {
                    do {
                        let decodData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodData))
                    } catch {
                        completion(.failure(error))
                    }
                }
            } else {
                let error = NSError(domain: "InvalidResponse", code: 0, userInfo: nil)
                completion(.failure(error))
            }
        }
        .resume()
        
    }
    
    
   
}


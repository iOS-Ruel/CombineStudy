//
//  BookSearchService.swift
//  CombineTest
//
//  Created by Chung Wussup on 5/6/24.
//

import Foundation
import Combine

struct SearchService {
    let url = URL(string: API_KEY)
    
    //TODO: - Combine을 사용하여 API호출하지
    func fetchBooks(searchText: String, page: Int) -> AnyPublisher<[Book], Error> {
        let url = self.url!
        let param = [URLQueryItem(name: "query", value: searchText),
                     URLQueryItem(name: "page", value: "\(page)"),
                     URLQueryItem(name: "size", value: "10"),
                     URLQueryItem(name: "sort", value: "latest")]
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = param
        
        guard let searchURL = urlComponents?.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: searchURL)
        request.httpMethod = "GET"
        request.setValue(AUTH_KEY, forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: BookDocument.self, decoder: JSONDecoder())
            .map { $0.documents }
            .eraseToAnyPublisher() // AnyPublisher 타입으로 변환시켜줌
    }
    
}

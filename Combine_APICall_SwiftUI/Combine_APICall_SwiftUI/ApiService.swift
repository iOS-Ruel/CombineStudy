//
//  ApiService.swift
//  Combine_APICall_SwiftUI
//
//  Created by Chung Wussup on 4/18/24.
//

import Foundation
import Combine

enum API {
    case fetchTodos
    case fetchPosts
    
    var url: URL {
        switch self {
        case .fetchTodos:
            return URL(string: "https://jsonplaceholder.typicode.com/todos")!
        case .fetchPosts:
            return URL(string: "https://jsonplaceholder.typicode.com/posts")!
        }
    }
    
    
    
    
}

enum ApiService {
    static func fetchTodos() -> AnyPublisher<[Todo], Error> {
        return URLSession.shared.dataTaskPublisher(for: API.fetchTodos.url)
            .map { $0.data }
            .decode(type: [Todo].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    static func fetchPosts() -> AnyPublisher<[Post], Error> {
        return URLSession.shared.dataTaskPublisher(for: API.fetchPosts.url)
            .map { $0.data }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    //post, todo 동시 호출
    static func fetchTodosAndPostsAtTheSameTime() -> AnyPublisher<([Todo], [Post]), Error> {
        
        let fetchedTodos = fetchTodos()
        let fetchedPosts = fetchPosts()
        
        return Publishers.CombineLatest(fetchedTodos, fetchedPosts)
                .eraseToAnyPublisher()
                
        
    }
}

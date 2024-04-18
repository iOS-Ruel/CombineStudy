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
        print("APIService - fetchTodos ")
        return URLSession.shared.dataTaskPublisher(for: API.fetchTodos.url)
            .map { $0.data }
            .decode(type: [Todo].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    static func fetchPosts(_ todosCount: Int = 0) -> AnyPublisher<[Post], Error> {
        print("todosPosts PostCount : " ,todosCount)
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
    
    //Todos 호출뒤 결과로 Posts 호출
    static func fetchTodosAndThenPosts() -> AnyPublisher<[Post], Error> {
        return fetchTodos()
            .flatMap { todos in
                return fetchPosts(todos.count)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    //Todos 호출뒤 결과로 특정 조건 성립되면 Posts 호출
    static func fetchTodosAndPostsApiCallConditionally() -> AnyPublisher<[Post], Error> {
        return fetchTodos()
            .map { $0.count }
            .filter{ $0 >= 200}
            .flatMap { _ in
                return fetchPosts()
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    
}

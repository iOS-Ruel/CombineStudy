//
//  ApiService.swift
//  Combine_APICall_SwiftUI
//
//  Created by Chung Wussup on 4/18/24.
//

import Foundation
import Combine
import Alamofire

enum API {
    case fetchTodos
    case fetchPosts
    case fetchUsers
    
    var url: URL {
        switch self {
        case .fetchTodos:
            return URL(string: "https://jsonplaceholder.typicode.com/todos")!
        case .fetchPosts:
            return URL(string: "https://jsonplaceholder.typicode.com/posts")!
        case .fetchUsers:
            return URL(string: "https://jsonplaceholder.typicode.com/users")!
        }
    }
    
}

enum ApiService {
    static func fetchUsers() -> AnyPublisher<[User], Error> {
        print("APIService - fetchTodos ")
//        return URLSession.shared.dataTaskPublisher(for: API.fetchUsers.url)
//            .map { $0.data }
//            .decode(type: [User].self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
        return AF.request(API.fetchUsers.url)
        //publishDecodable를 사용하면  디코딩도해주고 Publish로 내뱉음
            .publishDecodable(type: [User].self)
            .value()
            //[User], AFError이기 때문에 Error타입을 변경해주어야함
            .mapError{ (aferrer: AFError) in
                return aferrer as Error
            }
            .eraseToAnyPublisher()
    }
    
    static func fetchTodos() -> AnyPublisher<[Todo], Error> {
        print("APIService - fetchTodos ")
//        return URLSession.shared.dataTaskPublisher(for: API.fetchTodos.url)
//            .map { $0.data }
//            .decode(type: [Todo].self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
        return AF.request(API.fetchTodos.url)
        //publishDecodable를 사용하면  디코딩도해주고 Publish로 내뱉음
            .publishDecodable(type: [Todo].self)
            .value()
            //[User], AFError이기 때문에 Error타입을 변경해주어야함
            .mapError{ (aferrer: AFError) in
                return aferrer as Error
            }
            .eraseToAnyPublisher()
    }
    
    static func fetchPosts(_ todosCount: Int = 0) -> AnyPublisher<[Post], Error> {
        print("todosPosts PostCount : " ,todosCount)
//        return URLSession.shared.dataTaskPublisher(for: API.fetchPosts.url)
//            .map { $0.data }
//            .decode(type: [Post].self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
        return AF.request(API.fetchPosts.url)
        //publishDecodable를 사용하면  디코딩도해주고 Publish로 내뱉음
            .publishDecodable(type: [Post].self)
            .value()
            //[User], AFError이기 때문에 Error타입을 변경해주어야함
            .mapError{ (aferrer: AFError) in
                return aferrer as Error
            }
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

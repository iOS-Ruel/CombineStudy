//
//  ViewModel.swift
//  Combine_APICall_SwiftUI
//
//  Created by Chung Wussup on 4/18/24.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
 
    
    var subsciptions = Set<AnyCancellable>()
    
    func fetchTodos() {
        ApiService.fetchTodos()
            .sink { completion in
                switch completion {
                case .finished :
                    print("ViewModel - fechTodos finished")
                case .failure(let error):
                    print("ViewModel - fetchTodos: err: \(error)")
                }
            } receiveValue: { todos in
                print("Todos : \(todos.count)")
            }
            .store(in: &subsciptions)

    }
    
    func fetchPosts() {
        ApiService.fetchPosts()
            .sink { completion in
                switch completion {
                case .finished:
                    print("ViewModel - fetchPosts finished")
                case .failure(let error):
                    print("ViewModel - fetchPosts: err: \(error)")
                }
            } receiveValue: { posts in
                print("Post : \(posts.count)")
            }
            .store(in: &subsciptions)

    }
    
    //todos + posts 동시호출
    func fetchTodosAndPostsAtTheSameTime() {
        ApiService.fetchTodosAndPostsAtTheSameTime()
            .sink { completion in
                switch completion {
                case .finished:
                    print("ViewModel - fetchTodosAndPostsAtTheSameTime finished")
                case .failure(let error):
                    print("ViewModel - fetchTodosAndPostsAtTheSameTime: err: \(error)")
                }
            } receiveValue: { (todos, posts) in
                print("Todos count : \(todos.count)")
                print("Post count : \(posts.count)")
            }
            .store(in: &subsciptions)
    }
    
    //todos 호출후 응답 받은 후  posts 호출
    func fetchTodosAndThenPosts() {
        ApiService.fetchTodosAndThenPosts()
            .sink { completion in
                switch completion {
                case .finished:
                    print("ViewModel - fetchTodosAndThenPosts finished")
                case .failure(let error):
                    print("ViewModel - fetchTodosAndThenPosts: err: \(error)")
                }
            } receiveValue: {posts in
                
                print("Post count : \(posts.count)")
            }
            .store(in: &subsciptions)
    }
    
    //todos 호출후 응답에 따른 조건으로 Posts 호출
    func fetchTodosAndPostsApiCallConditionally() {
        ApiService.fetchTodosAndPostsApiCallConditionally()
            .sink { completion in
                switch completion {
                case .finished:
                    print("ViewModel - fetchTodosAndPostsApiCallConditionally finished")
                case .failure(let error):
                    print("ViewModel - fetchTodosAndPostsApiCallConditionally: err: \(error)")
                }
            } receiveValue: {posts in
                
                print("Post count : \(posts.count)")
            }
            .store(in: &subsciptions)
    }
    
    
    //Todos 호출 후 응답에 따른 조건으로 다음 api 호출 결정
    //Todos.count < 200 : 포스트 호출 ? 유저 호출
    func fetchTodosAndApiCallConditionally() {
        let shouldFetchPosts : AnyPublisher<Bool, Error> = ApiService.fetchTodos()
                                                                        .map{ $0.count < 200 }
                                                                        .eraseToAnyPublisher()
        print(shouldFetchPosts)
        shouldFetchPosts
            .filter { $0 == true }
            .flatMap { _ in
                return ApiService.fetchPosts()
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("ViewModel - fetchTodosAndPostsApiCallConditionally finished")
                case .failure(let error):
                    print("ViewModel - fetchTodosAndPostsApiCallConditionally: err: \(error)")
                }
            } receiveValue: {posts in
                
                print("Post count : \(posts.count)")
            }
            .store(in: &subsciptions)
        
        shouldFetchPosts
            .filter { $0 != true }
            .flatMap { _ in
                return ApiService.fetchUsers()
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("ViewModel - fetchTodosAndPostsApiCallConditionally finished")
                case .failure(let error):
                    print("ViewModel - fetchTodosAndPostsApiCallConditionally: err: \(error)")
                }
            } receiveValue: {users in
                
                print("users count : \(users.count)")
            }
            .store(in: &subsciptions)
        
    }
    
}

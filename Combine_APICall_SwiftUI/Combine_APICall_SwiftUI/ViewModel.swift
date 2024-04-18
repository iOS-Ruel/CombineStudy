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
    
    //todos 호출후 응답에 따른 조건으로 Posts 호출
    func fetchTodosAndApiCallConditionally() {
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
    
    
}

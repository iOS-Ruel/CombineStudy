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
    
    
}

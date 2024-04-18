//
//  ContentView.swift
//  Combine_APICall_SwiftUI
//
//  Created by Chung Wussup on 4/18/24.
//

import SwiftUI

//https://jsonplaceholder.typicode.com/ Dummy 사용

struct ContentView: View {
//    @StateObject var viewModel: ViewModel = ViewModel()
    @StateObject var viewModel: ViewModel
    
    init() {
        self._viewModel = StateObject.init(wrappedValue: ViewModel())
    }
    
    var body: some View {
        VStack {
            Button {
                self.viewModel.fetchTodos()
            } label: {
                Text("Todos 호출")
                    .foregroundStyle(.white)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(.gray))
            
            Button {
                self.viewModel.fetchPosts()
            } label: {
                Text("Posts 호출")
                    .foregroundStyle(.white)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(.gray))
            
            Button {
                self.viewModel.fetchTodosAndPostsAtTheSameTime()
            } label: {
                Text("Todos + Posts 동시 호출")
                    .foregroundStyle(.white)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(.gray))
            
        }
        
    }
}

#Preview {
    ContentView()
}

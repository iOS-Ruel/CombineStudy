//
//  ContentView.swift
//  Combine_APICall_SwiftUI
//
//  Created by Chung Wussup on 4/18/24.
//

import SwiftUI

//https://jsonplaceholder.typicode.com/ Dummy 사용

struct ContentView: View {
    var body: some View {
        VStack {
            Button {
                
            } label: {
                Text("Todos 호출")
                    .foregroundStyle(.white)
            }
            .background(RoundedRectangle(cornerRadius: 10).fill(.gray))
            
            
        }
        
    }
}

#Preview {
    ContentView()
}

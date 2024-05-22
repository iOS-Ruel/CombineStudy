//
//  SearchViewModel.swift
//  CombineTest
//
//  Created by Chung Wussup on 5/6/24.
//

import Foundation
import Combine

class SearchViewModel {
    let service = SearchService()
    
    private var pageCnt = 0
    private let defaultSearchText = "iOS"
    private var cancellables = Set<AnyCancellable>()
    
    @Published var bookList: [Book] = []
    var isFetching = false
    
    func fetchBookList(searchText: String? = nil, isRefresh: Bool = false) {
        isFetching = true
        
        if isRefresh {
            pageCnt = 1
        } else {
            pageCnt += 1
        }
        
        let query = searchText ?? defaultSearchText
        
        // 기존 구독을 취소
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        service.fetchBooks(searchText: query, page: pageCnt)
            .sink { [weak self] completion in
                guard case .failure(let error) = completion else { return }
                self?.isFetching = false
                print("Error fetching books: \(error)")
                
            } receiveValue: { [weak self] books in
                guard let self = self else { return }
                self.isFetching = false
                if self.pageCnt == 1 {
                    self.bookList = books
                } else {
                    if !books.isEmpty {
                        self.bookList.append(contentsOf: books)
                    }
                }
            }
            .store(in: &cancellables)
    }
}

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
    var books: [Book] = []
    private var pageCnt = 0
    private let defaultSearchText = "iOS"
    var isFetchingData = false
    
    
    //MARK: - Combine을 사용하지 않고 API 호출 요청을 받아 데이터를 가져옴
    func fetchBooks(searchText: String? = nil,
                    isRefresh: Bool = false,
                    compltion: @escaping() -> Void) {
        
        isFetchingData = true
        
        if isRefresh {
            pageCnt = 1
        } else {
            pageCnt += 1
        }
        
        let query = searchText ?? defaultSearchText
        
        service.bookSearchReqeuset(searchText: query,
                                   page: pageCnt) { [weak self] books in
            
            self?.isFetchingData = false
            
            if self?.pageCnt == 1 {
                self?.books = books
            } else {
                if !books.isEmpty {
                    self?.books.append(contentsOf: books)
                }
            }
            
            compltion()
        }
    }
    
    
    private var cancellables = Set<AnyCancellable>()
    //@Published와 Subject는 같은 역할을 하긴함
    //그러나 Subject를 사용할경우 Book 데이터를 append 하지 못함
    //Subject를 사용하면 [Book] 타입의 변수를 선언해주고 append 후 send를 해주어야하는 상황이 발생함
    //따라서 현상황에서 데이터를 append 할 수 있는 @Published를 사용하였음
    @Published var bookList: [Book] = []
    //    var booksList = CurrentValueSubject<[Book], Never>([])
    //    var booksList = PassthroughSubject<[Book], Never>()
    var isFetching = false
    
    //MARK: - Combine을 사용하여 API호출
    func fetchBookList(searchText: String? = nil, isRefresh: Bool = false) {
        isFetching = true
        
        if isRefresh {
            pageCnt = 1
        } else {
            pageCnt += 1
        }
        
        let query = searchText ?? defaultSearchText
        
        service.fetchBooks(searchText: query, page: pageCnt)
            .sink { [weak self] completion in
                guard case .failure(_) = completion else { return }
                self?.isFetching = false
                
            } receiveValue: { [weak self] books in
                guard let self = self else { return }
                self.isFetching = false
                if self.pageCnt == 1 {
                    self.bookList = books
                } else {
                    if !bookList.isEmpty {
                        self.bookList.append(contentsOf: books)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
}
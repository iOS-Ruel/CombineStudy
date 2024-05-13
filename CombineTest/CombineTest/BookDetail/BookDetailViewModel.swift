//
//  BookDetailViewModel.swift
//  CombineTest
//
//  Created by Chung Wussup on 5/11/24.
//

import UIKit
import Combine

class BookDetailViewModel {
    let book: Book
    
    private let service = BookDetailService()
    private var cancellables = Set<AnyCancellable>()
    @Published var bookImage: UIImage?
    
    init(book: Book) {
        self.book = book
        
        if !book.thumbnail.isEmpty {
            service.downloadImage(url: book.thumbnail)
                .sink { completion in
                    guard case .failure(_) = completion else { return }
                } receiveValue: { [weak self] bookImage in
                    guard let self = self else { return }
                    self.bookImage = bookImage
                }
                .store(in: &cancellables)
        }
    }
    
    
}

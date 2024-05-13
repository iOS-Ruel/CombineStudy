//
//  BookDetailService.swift
//  CombineTest
//
//  Created by Chung Wussup on 5/12/24.
//

import UIKit
import Combine

struct BookDetailService {
    
    func downloadImage(url: String) -> AnyPublisher<UIImage, Error> {
        let imageUrl = URL(string: url)
        
        return URLSession.shared.dataTaskPublisher(for: imageUrl!)
                .tryMap { data, response in
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        throw URLError(.badServerResponse)
                    }
                    return data
                }
                .tryMap { data in
                    guard let image = UIImage(data: data) else {
                        throw NSError(domain: "ImageErrorDomain", code: -1, userInfo: nil)
                    }
                    return image
                }
                .eraseToAnyPublisher()
    }

}

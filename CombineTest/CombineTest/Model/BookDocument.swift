//
//  BookDocument.swift
//  CombineTest
//
//  Created by Chung Wussup on 5/6/24.
//

import Foundation

struct BookDocument: Codable {
    let documents: [Book]
    let meta: Meta
}


struct Meta: Codable {
    let is_end: Bool
    let pageable_count: Int
    let total_count: Int
}

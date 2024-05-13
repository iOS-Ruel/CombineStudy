//
//  String.swift
//  CombineTest
//
//  Created by Chung Wussup on 5/8/24.
//

import Foundation

extension String {
    func stringToDate(dateFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        guard let convertDate = dateFormatter.date(from: self) else {
            return Date()
        }
        
        return convertDate
    }
}

//
//  Extension_Date.swift
//  CombineTest
//
//  Created by Chung Wussup on 5/8/24.
//

import Foundation

extension Date {
    func dateToString(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        let convertDate = dateFormatter.string(from: self)

        return convertDate
    }
}


    
    


//
//  Book.swift
//  CombineTest
//
//  Created by Chung Wussup on 5/6/24.
//

import Foundation
/**
#Book Model Description
 - Books 
     - title: 도서 제목
     - contents: 도서 소개
     - url: 도서 상세 URL
     - isbn : ISBN10(10자리) 또는 ISBN13(13자리) 형식의 국제 표준 도서번호 - ISBN10 또는 ISBN13 중 하나 이상 포함 - 두 값이 모두 제공될 경우 공백(' ')으로 구분
     - datetime: 도서 출판날짜, ISO 8601 형식 - [YYYY]-[MM]-[DD]T[hh]:[mm]:[ss].000+[tz]
     - authors: 도서 저자 리스트
     - publisher: 도서 출판사
     - translators: 도서 번역자 리스트
     - price: 도서 정가
     - sale_price: 도서 판매가
     - thumbnail: 도서 표지 미리보기 URL
     - status: 도서 판매 상태 정보(정상, 품절, 절판 등) 상황에 따라 변동 가능성이 있으므로 문자열 처리 지양, 단순 노출 요소로 활용 권장
**/
struct Book: Codable {
    let authors: [String]
    let contents: String
    let datetime: String
    let isbn: String
    let price: Int
    let publisher: String
    let sale_price: Int
    let status: String
    let thumbnail: String
    let title: String  //도서 제목
    let translators: [String]
    let url: String
    
    var dateString: String {
        let date = datetime.stringToDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        return date.dateToString(dateFormat: "yyyy년MM월dd일")
    }
    
    var commaPrice: String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        let result: String = "\(numberFormatter.string(for: price)!)원"
        return result
    }
    
    var commaSalePrice: String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        let result: String = "\(numberFormatter.string(for: sale_price)!)원"
        return result
    }
}

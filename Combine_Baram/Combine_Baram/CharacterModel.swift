//
//  CharacterModel.swift
//  Combine_Baram
//
//  Created by Chung Wussup on 6/1/24.
//

import Foundation


struct CharacterOcid: Codable {
    let ocid: String
}


struct CharacterBasic: Codable {
    let name: String
    let dateCreate: String?
    let dateLastLogin: String
    let dateLastLogout: String
    let createTypeName: String
    let className: String
    let nationName: String
    let gender: String
    let exp: Int
    let level: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "character_name"
        case dateCreate = "character_date_create"
        case dateLastLogin = "character_date_last_login"
        case dateLastLogout = "character_date_last_logout"
        case createTypeName = "character_create_type_name"
        case className = "character_class_name"
        case nationName = "character_nation_name"
        case gender = "character_gender"
        case exp = "character_exp"
        case level = "character_level"
    }
    
    
}

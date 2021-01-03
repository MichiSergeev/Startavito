//
//  JSONModel.swift
//  avito1
//
//  Created by Mikhail Sergeev on 03.01.2021.
//

import Foundation

struct InfoBlockJSON: Codable {
    let id: String
    let title: String
    let description: String
    let icon: [String : String]
    let price:String
    let isSelected:Bool
}

struct ResultJSON: Codable {
    let title: String
    let actionTitle: String
    let selectedActionTitle: String
    let list: [InfoBlockJSON]
}

struct TopLevelJSON: Codable {
    let status: String
    let result: ResultJSON
}




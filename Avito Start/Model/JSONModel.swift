//
//  JSONModel.swift
//  avito1
//
//  Created by Mikhail Sergeev on 03.01.2021.
//

import Foundation

struct SpecialService: Codable {
    let id: String
    let title: String
    let description: String?
    let icon: [String : String]
    let price: String
    let isSelected: Bool
}

struct ResultJSON: Codable {
    let title: String
    let actionTitle: String
    let selectedActionTitle: String
    let list: [SpecialService]
}

struct TopLevelJSON: Codable {
    let status: String
    let result: ResultJSON
}




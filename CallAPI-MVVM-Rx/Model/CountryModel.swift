//
//  Country.swift
//  CallAPI-MVVM-Rx
//
//  Created by Nguyễn Đình Trung Đức on 27/12/2021.
//

import Foundation

struct CountryModel: Codable {
    let code: Int?
    let result: [CountryListModel]?
    
    private enum CodingKeys: String, CodingKey {
        case code
        case result
    }
}
struct CountryListModel: Codable {
    let code: String
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case code
        case name
    }
}

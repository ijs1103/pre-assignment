//
//  SearchedData.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/27.
//

import Foundation

struct SearchedData: Codable {
    var id: String {
        return category+keyword
    }
    let category: String
    let keyword: String
}

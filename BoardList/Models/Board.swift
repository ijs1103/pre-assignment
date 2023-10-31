//
//  Board.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/26.
//

import Foundation

struct BoardResponse: Codable {
    let value: [Board]
    let count, offset, limit, total: Int
}

struct Board: Codable {
    let boardId: Int
    let displayName, boardType: String
    let isFavorite, hasNewPost: Bool
    let orderNo: Int
    let capability: Capability
}

struct Capability: Codable {
    let writable, manageable: Bool
}

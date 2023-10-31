//
//  Post.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/26.
//

import Foundation

struct PostResponse: Codable {
    let value: [Post]
    let count, offset, limit, total: Int
}

struct Post: Codable {
    let postId: Int
    let title: String
    let boardId: Int
    let boardDisplayName: String
    let writer: Writer
    let contents: String
    let createdDateTime: String
    let viewCount: Int
    let postType: String
    let isNewPost: Bool
    let hasInlineImage: Bool
    let commentsCount: Int
    let attachmentsCount: Int
    let isAnonymous, isOwner, hasReply: Bool
}

struct Writer: Codable {
    let displayName, emailAddress: String
}

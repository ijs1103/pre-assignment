//
//  PostCellVM.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/26.
//

import Foundation

struct PostCellVM {
    let post: Post
    
    var title: String {
        if post.title.contains("[Re]") {
            return post.title.substring(from: 4, to: post.title.count - 1)
        } else {
            return post.title
        }
    }
    
    var writer: String {
        return post.writer.displayName
    }
    
    var createdAt: String {
        return "• \(post.createdDateTime.prefix(10)) •"
    }
    
    var viewCount: String {
        return String(post.viewCount)
    }
    
    var hasAttachment: Bool {
        return post.attachmentsCount > 0
    }
    
    var hasNoticeIcon: Bool {
        return post.postType == "notice"
    }
    
    var hasReplIcon: Bool {
        return post.postType == "reply"
    }
    
    var isNewPost: Bool {
        return post.isNewPost
    }
}

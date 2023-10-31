//
//  BoardVM.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/26.
//

import Foundation
import Combine

final class BoardVM {
    
    static let shared = BoardVM()
    private init() {}
    
    private let network = NetworkService(configuration: .default)
    let posts = CurrentValueSubject<[Post]?, Never>([])
    let isLoading = CurrentValueSubject<Bool, Never>(false) // 현재 네트워킹중인지 확인하는 flag 변수
    private var page = 0
    private let LIMIT = 30
    var isEnd = false // 더이상 불러올 데이터가 없음을 판단하는 flag 변수
    var subscriptions = Set<AnyCancellable>()
}

extension BoardVM {
    // 다른 게시판으로 변경될때마다 VM을 초기화 하는 함수
    func reset() {
        posts.send(nil)
        page = 0
        isEnd = false
    }
    
    func fetchPosts(boardId: Int) {
        guard !isLoading.value, !isEnd else { return }
        if page > 0 {
            isLoading.send(true)
        }
        let params = [
            "offset": String(page * LIMIT),
            "limit": String(LIMIT * (page + 1))
        ]
        let headers = ["Authorization": Constants.bearerToken]
        let resource = NetworkResource<PostResponse>(baseUrl: Constants.url.posts(id: boardId), params: params, headers: headers)
        network.load(resource)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.posts.send(nil)
                    debugPrint("posts fetch error: \(error)")
                case .finished: break
                }
            } receiveValue: { res in
                if res.limit >= res.total {
                    self.isEnd = true
                    print("게시판 끝 도달")
                }
                if let posts = self.posts.value {
                    var currentPosts = posts
                    currentPosts.append(contentsOf: res.value)
                    self.posts.send(currentPosts)
                } else {
                    self.posts.send(res.value)
                }
                self.page += 1
                self.isLoading.send(false)
            }
            .store(in: &subscriptions)
    }
}


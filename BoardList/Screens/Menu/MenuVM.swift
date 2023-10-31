//
//  MenuVM.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/26.
//

import Foundation
import Combine

final class MenuVM {
    private let network = NetworkService(configuration: .default)
    let boards = CurrentValueSubject<[Board]?, Never>(nil)
    var subscriptions = Set<AnyCancellable>()
    init() {
        fetchBoards()
    }
}

extension MenuVM {
    func fetchBoards() {
        let headers = ["Authorization": Constants.bearerToken]
        let resource = NetworkResource<BoardResponse>(baseUrl: Constants.url.boards, headers: headers)
        network.load(resource)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.boards.send(nil)
                    debugPrint("boards fetch error: \(error)")
                case .finished: break
                }
            } receiveValue: { res in
                // 게시판을 orderNo 기준 오름차순 정렬
                let sorted = res.value.sorted { a, b in
                    a.orderNo < b.orderNo
                }
                self.boards.send(sorted)
            }
            .store(in: &subscriptions)
    }
}

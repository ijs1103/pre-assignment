//
//  SearchVM.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/27.
//

import Foundation
import Combine

enum SearchTarget: String, CaseIterable {
    case all, title, contents, writer
    var text: String {
        switch self {
        case .all:
            return "전체"
        case .title:
            return "제목"
        case .contents:
            return "내용"
        case .writer:
            return "작성자"
        }
    }
}

final class SearchVM {
    private let boardId: Int
    private let network = NetworkService(configuration: .default)
    let results = CurrentValueSubject<[Post]?, Never>(nil)
    let searchedDatas = CurrentValueSubject<[SearchedData]?, Never>(nil)
    let currentKeyword = CurrentValueSubject<String, Never>("")
    var subscriptions = Set<AnyCancellable>()
    init(boardId: Int) {
        self.boardId = boardId
        fetchSearchedData()
    }
}

extension SearchVM {
    func fetchSearchedData() {
        self.searchedDatas.send(LocalDB.searchedData())
    }
    
    func deleteSearchedData(id: String) {
        LocalDB.deleteSearchedData(id: id)
        self.searchedDatas.send(LocalDB.searchedData())
    }
    
    func search(_ keyword: String, searchTarget: SearchTarget) {
        LocalDB.setSearchedData(data: SearchedData(category: searchTarget.rawValue, keyword: keyword))
        fetchResults(keyword, searchTarget: searchTarget)
    }
    
    func fetchResults(_ keyword: String, searchTarget: SearchTarget) {
        let headers = ["Authorization": Constants.bearerToken]
        let params = ["search": keyword, "searchTarget": searchTarget.rawValue, "offset": "0", "limit": "30"]
        let resource = NetworkResource<PostResponse>(baseUrl: Constants.url.posts(id: boardId), params: params, headers: headers)
        network.load(resource)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.results.send(nil)
                    debugPrint("boards fetch error: \(error)")
                case .finished: break
                }
            } receiveValue: { res in
                self.results.send(res.value)
            }
            .store(in: &subscriptions)
    }
}

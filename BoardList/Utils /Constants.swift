//
//  Constants.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/23.
//

import Foundation

struct Constants {
    
    static let bearerToken = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2ODgxMDM5NDAsImV4cCI6MCwidXNlcm5hbWUiOiJtYWlsdGVzdEBtcC1kZXYubXlwbHVnLmtyIiwiYXBpX2tleSI6IiMhQG1wLWRldiFAIyIsInNjb3BlIjpbImVhcyJdLCJqdGkiOiI5MmQwIn0.Vzj93Ak3OQxze_Zic-CRbnwik7ZWQnkK6c83No_M780"

    struct url {
        static let boards = "https://mp-dev.mail-server.kr/api/v2/boards"
        static func posts(id: Int) -> String {
            return "https://mp-dev.mail-server.kr/api/v2/boards/\(id)/posts"
        }
    }
}

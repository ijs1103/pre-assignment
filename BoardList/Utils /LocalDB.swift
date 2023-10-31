//
//  LocalDB.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/27.
//

import Foundation

struct LocalDB {
    static func searchedData() -> [SearchedData] {
        guard let data = UserDefaults.standard.object(forKey: "searchedData") as? Data else {
            print("UserDefaults - no data")
            return []
        }
        guard let decoded = try? JSONDecoder().decode([SearchedData].self, from: data) else {
            print("UserDefaults - decode error")
            return []
        }
        return decoded
    }
    static func setSearchedData(data: SearchedData) {
        let newId = data.id
        var datas = searchedData()
        let isExisting = !datas.filter({
            $0.id == newId
        }).isEmpty
        if isExisting { return }
        datas.insert(data, at: 0)
        guard let encoded = try? JSONEncoder().encode(datas) else {
            print("UserDefaults - encode error")
            return
        }
        UserDefaults.standard.set(encoded, forKey: "searchedData")
    }
    static func deleteSearchedData(id: String, isAll: Bool = false) {
        let datas = searchedData()
        if datas.isEmpty { return }
        if isAll {
            UserDefaults.standard.removeObject(forKey: "searchedData")
        } else {
            let filterd = datas.filter({ $0.id != id })
            guard let encoded = try? JSONEncoder().encode(filterd) else {
                print("UserDefaults - encode error")
                return
            }
            UserDefaults.standard.set(encoded, forKey: "searchedData")
        }
    }
}

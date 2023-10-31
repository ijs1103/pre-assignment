//
//  NSMutableAttributedString+.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/27.
//

import Foundation

extension NSMutableAttributedString {
    func category(string: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [.font: Theme.Font.regular(ofSize: 14), .foregroundColor: Theme.Color.subTitle]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    func keyword(string: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [.font: Theme.Font.regular(ofSize: 16), .foregroundColor: Theme.Color.font]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
}

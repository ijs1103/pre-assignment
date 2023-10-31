//
//  SeparatorView.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/24.
//

import UIKit

final class SeparatorView: UIView {
    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(displayP3Red: 229/255, green: 229/255, blue: 233/255, alpha: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

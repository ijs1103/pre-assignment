//
//  PaddingLabel.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/26.
//

import UIKit

final class PaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}

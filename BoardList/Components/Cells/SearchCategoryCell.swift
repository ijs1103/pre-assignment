//
//  SearchCategoryCell.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/27.
//

import UIKit

final class SearchCategoryCell: UITableViewCell {
    
    static let identifier = "SearchCategoryCell"
            
    private lazy var title: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var disclosure: UIImageView = {
        let view = UIImageView(image: .init(named: "chevronRight"))
        view.widthAnchor.constraint(equalToConstant: 6.47).isActive = true
        view.heightAnchor.constraint(equalToConstant: 12.09).isActive = true
        view.tintColor = Theme.Color.chevron
        return view
    }()

    private lazy var hStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [title, disclosure])
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
}

extension SearchCategoryCell {
    
    func configure(target: SearchTarget, keyword: String) {
        title.attributedText = NSMutableAttributedString().category(string: "\(target.text) : ")
            .keyword(string: keyword)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .white
                
        [ hStack ].forEach {
            addSubview($0)
        }
        
        hStack.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(14)
        }
        
    }
}

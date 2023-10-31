//
//  RecentSearchCell.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/27.
//

import UIKit

protocol RecentSearchCellDelegate: AnyObject {
    func didTapDelete(searchedDataId: String)
}

final class RecentSearchCell: UITableViewCell {
    
    static let identifier = "RecentSearchCell"
    
    weak var delegate: RecentSearchCellDelegate?
    
    private var id: String = ""
    
    private lazy var title: UILabel = {
        let label = UILabel()
        return label
    }()
            
    private lazy var category: UILabel = {
        let label = LabelFactory.build(text: nil, font: Theme.Font.regular(ofSize: 14), textColor: Theme.Color.subTitle)
        return label
    }()
    
    private lazy var keyword: UILabel = {
        let label = LabelFactory.build(text: nil, font: Theme.Font.regular(ofSize: 16), textColor: Theme.Color.font)
        return label
    }()

    
    private lazy var leftContentIcon: UIImageView = {
        let view = UIImageView(image: .init(named: "leftContent"))
        view.widthAnchor.constraint(equalToConstant: 24).isActive = true
        view.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return view
    }()
    
    private lazy var xIcon: UIImageView = {
        let view = UIImageView(image: .init(named: "xIcon"))
        view.widthAnchor.constraint(equalToConstant: 18).isActive = true
        view.heightAnchor.constraint(equalToConstant: 18).isActive = true
        let tgr = UITapGestureRecognizer(target: self, action: #selector(didTapDelete))
        view.addGestureRecognizer(tgr)
        view.isUserInteractionEnabled = true
        return view
    }()
    
//    private lazy var subHStack: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [category, keyword])
//        stackView.axis = .horizontal
//        stackView.alignment = .center
//        return stackView
//    }()

    private lazy var mainHStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [leftContentIcon, title, xIcon])
        stackView.spacing = 4
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
}

extension RecentSearchCell {
    
    func configure(data: SearchedData) {
        id = data.id
        if let category = SearchTarget(rawValue: data.category)?.text {
            title.attributedText = NSMutableAttributedString().category(string: "\(category) : ")
                .keyword(string: data.keyword)
        }
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .white
        
        [ mainHStack ].forEach {
            addSubview($0)
        }
        
        mainHStack.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(14)
        }
        
    }
    @objc private func didTapDelete() {
        delegate?.didTapDelete(searchedDataId: id)
    }
}

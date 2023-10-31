//
//  CustomEmptyView.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/25.
//

import UIKit
import SnapKit

enum EmptyType {
    case noData, noRecentSearch, noSearchResult
    var imageName: String {
        switch self {
        case .noData:
            return "empty"
        case .noRecentSearch:
            return "search1"
        case .noSearchResult:
            return "search2"
        }
    }
    var imageSize: CGSize {
        switch self {
        case .noData:
            return CGSize(width: 152, height: 160)
        case .noRecentSearch:
            return CGSize(width: 111, height: 172)
        case .noSearchResult:
            return CGSize(width: 151, height: 171)
        }
    }
    var text: String {
        switch self {
        case .noData:
            return "등록된 게시글이 없습니다."
        case .noRecentSearch:
            return "게시글의 제목, 내용 또는 작성자에 포함된 단어 또는 문장을 검색해 주세요."
        case .noSearchResult:
            return "검색 결과가 없습니다. 다른 검색어를 입력해 보세요."
        }
    }
}

final class CustomEmptyView: UIView {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
        
    private lazy var textLabel: UILabel = {
        let label = LabelFactory.build(text: nil, font: Theme.Font.regular(ofSize: 14), textColor: Theme.Color.font)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ imageView, textLabel ])
        stackView.spacing = 24.0
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CustomEmptyView {
    func configure(type: EmptyType) {
        imageView.image = UIImage(named: type.imageName)
        textLabel.text = type.text
        imageView.snp.makeConstraints {
            $0.width.equalTo(type.imageSize.width)
            $0.height.equalTo(type.imageSize.height)
        }
    }
    
    private func setupViews() {
        backgroundColor = Theme.Color.bg
    
        addSubview(vStack)

        vStack.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(250)
        }
    }
}

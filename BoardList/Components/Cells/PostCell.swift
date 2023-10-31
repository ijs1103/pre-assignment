//
//  PostCell.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/26.
//

import UIKit

final class PostCell: UITableViewCell {
    
    static let identifier = "PostCell"
    
    private var viewModel: PostCellVM?
    
    private lazy var title: UILabel = {
        let label = LabelFactory.build(text: nil, font: Theme.Font.regular(ofSize: 16), textColor: Theme.Color.title)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var noticeLabel: UILabel = {
        let label = PaddingLabel()
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.text = "공지"
        label.font = Theme.Font.regular(ofSize: 12)
        label.backgroundColor = Theme.Color.noticeLabel
        label.textColor = .white
        return label
    }()
    
    private lazy var replLabel: UILabel = {
        let label = PaddingLabel()
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.text = "Re"
        label.font = Theme.Font.regular(ofSize: 12)
        label.backgroundColor = Theme.Color.replLabel
        label.textColor = .white
        return label
    }()
    
    private lazy var writer: UILabel = {
        LabelFactory.build(text: nil, font: Theme.Font.thin(ofSize: 12), textColor: Theme.Color.subTitle)
    }()
    
    private lazy var createdAt: UILabel = {
        LabelFactory.build(text: nil, font: Theme.Font.thin(ofSize: 12), textColor: Theme.Color.subTitle)
    }()
    
    private lazy var viewCount: UILabel = {
        LabelFactory.build(text: nil, font: Theme.Font.thin(ofSize: 12), textColor: Theme.Color.subTitle)
    }()
    
    private lazy var attachmentIcon: UIImageView = {
        let view = UIImageView(image: .init(named: "attachment"))
        view.widthAnchor.constraint(equalToConstant: 16).isActive = true
        view.heightAnchor.constraint(equalToConstant: 16).isActive = true
        return view
    }()
    
    private lazy var newIcon: UIImageView = {
        let view = UIImageView(image: .init(named: "new"))
        view.widthAnchor.constraint(equalToConstant: 16).isActive = true
        view.heightAnchor.constraint(equalToConstant: 16).isActive = true
        return view
    }()
    
    private lazy var eyeIcon: UIImageView = {
        let view = UIImageView(image: .init(named: "eye"))
        view.widthAnchor.constraint(equalToConstant: 16).isActive = true
        view.heightAnchor.constraint(equalToConstant: 16).isActive = true
        return view
    }()
    
    private lazy var mainHStack: UIStackView = {
        var subviews: [UIView] = [title]
        if let hasNoticeIcon = viewModel?.hasNoticeIcon, hasNoticeIcon {
            subviews.insert(noticeLabel, at: 0)
        }
        if let hasReplIcon = viewModel?.hasReplIcon, hasReplIcon {
            subviews.insert(replLabel, at: 0)
        }
        if let hasAttachment = viewModel?.hasAttachment, hasAttachment {
            subviews.append(attachmentIcon)
        }
        if let isNewPost = viewModel?.isNewPost, isNewPost {
            subviews.append(newIcon)
        }
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.spacing = 4.0
        stackView.axis = .horizontal
        stackView.alignment = .center

        return stackView
    }()
    
    private lazy var subHStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ writer, createdAt, eyeIcon, viewCount ])
        stackView.spacing = 2.0
        stackView.axis = .horizontal
        stackView.alignment = .top
        return stackView
    }()
    
    private lazy var vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ mainHStack, subHStack ])
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()

}

extension PostCell {
    
    func configure(post: Post) {
        viewModel = PostCellVM(post: post)
        if let viewModel = viewModel {
            title.text = viewModel.title
            writer.text = viewModel.writer
            createdAt.text = viewModel.createdAt
            viewCount.text = viewModel.viewCount
        }
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        
        [ vStack ].forEach {
            addSubview($0)
        }
        
        vStack.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}


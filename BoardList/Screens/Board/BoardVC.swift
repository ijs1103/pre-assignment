//
//  BoardVC.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/26.
//

import UIKit
import Combine

final class BoardVC: UIViewController {
    private let viewModel = BoardVM.shared
    private var subscriptions = Set<AnyCancellable>()
    private let boardId: Int
    private let boardName: String
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .white
        table.dataSource = self
        table.delegate = self
        table.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        let backgroundView = CustomEmptyView()
        backgroundView.configure(type: .noData)
        table.backgroundView = backgroundView
        table.separatorStyle = .none
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavi()
        configViews()
        bind()
    }
    
    init(boardId: Int, boardName: String) {
        self.boardId = boardId
        self.boardName = boardName
        super.init(nibName: nil, bundle: nil)
        viewModel.reset()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BoardVC {
    private func configNavi() {
        let label = UILabel()
        label.text = boardName
        label.textAlignment = .left
        label.font = Theme.Font.regular(ofSize: 22)
        let image = UIImage(systemName: "line.3.horizontal")
        let leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapLeftBarButtonItem))
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapRightBarButtonItem))
        navigationItem.leftBarButtonItems = [leftBarButtonItem, UIBarButtonItem(customView: label)]
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    @objc func didTapLeftBarButtonItem() {
        let vc = MenuVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapRightBarButtonItem() {
        let vc = SearchVC(boardId: boardId, boardName: boardName)
        navigationController?.pushViewController(vc, animated: true)
    }
    private func configViews() {
        self.tableView.backgroundView?.isHidden = true
        [tableView].forEach {
            view.addSubview($0)
        }
        tableView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16.0)
            $0.leading.trailing.equalToSuperview()
        }
    }
    private func bind() {
        viewModel.posts
            .receive(on: RunLoop.main)
            .sink { [unowned self] posts in
                guard let posts = posts else { return }
                if posts.count > 0 {
                    self.tableView.backgroundView?.isHidden = true
                } else {
                    self.tableView.backgroundView?.isHidden = false
                }
                self.tableView.reloadData()
            }.store(in: &subscriptions)
        
        viewModel.isLoading
            .receive(on: RunLoop.main)
            .sink { [unowned self] isLoading in
                self.tableView.tableFooterView = isLoading ? self.showSpinnerInFooter() : nil
            }.store(in: &subscriptions)
    }
    private func showSpinnerInFooter() -> UIView {
        let footerHeight: CGFloat = 100
        let footer = UIView(frame: .init(x: 0, y: 0, width: view.frame.size.width, height: footerHeight))
        let spinner = UIActivityIndicatorView()
        footer.addSubview(spinner)
        spinner.center = footer.center
        spinner.startAnimating()
        return footer
    }
}

extension BoardVC: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > tableView.contentSize.height - scrollView.frame.height {
            viewModel.fetchPosts(boardId: boardId)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
}

extension BoardVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell
        if let post = viewModel.posts.value?[indexPath.row] {
            cell?.configure(post: post)
        }
        cell?.selectionStyle = .none
        
        return cell ?? UITableViewCell()
    }
}

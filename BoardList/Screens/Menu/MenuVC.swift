//
//  MenuVC.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/23.
//

import UIKit
import Combine
import SnapKit

final class MenuVC: UIViewController {
    
    private let viewModel = MenuVM()
    private var subscriptions = Set<AnyCancellable>()
    private lazy var titleLabel: UILabel = {
        let label = LabelFactory.build(text: "게시판", font: Theme.Font.thin(ofSize: 14), textColor: Theme.Color.title)
        label.textAlignment = .left
        return label
    }()
    private lazy var separator = SeparatorView()
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .white
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavi()
        configViews()
        bind()
    }
}

extension MenuVC {
    private func configNavi() {
        let image = UIImage(systemName: "xmark")
        let leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapLeftBarButtonItem))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    @objc private func didTapLeftBarButtonItem() {
        navigationController?.popViewController(animated: true)
    }
    private func configViews() {
        [titleLabel, separator, tableView].forEach {
            view.addSubview($0)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(8.0)
            $0.leading.equalToSuperview().inset(16.0)
        }
        separator.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom).offset(8.0)
            $0.bottom.equalToSuperview().inset(16.0)
            $0.leading.trailing.equalToSuperview()
        }
    }
 
    private func bind() {
        viewModel.boards
            .receive(on: RunLoop.main)
            .sink { [unowned self] boards in
                self.tableView.reloadData()
            }.store(in: &subscriptions)
    }
}

extension MenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let row = viewModel.boards.value?[indexPath.item] {
            navigationController?.pushViewController(BoardVC(boardId: row.boardId, boardName: row.displayName), animated: true)
        }
    }
}

extension MenuVC: UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "게시판"
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.boards.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        var content = cell.defaultContentConfiguration()
        cell.selectionStyle = .none
        cell.textLabel?.font = Theme.Font.regular(ofSize: 16)
        if let row = viewModel.boards.value?[indexPath.row] {
            content.text = row.displayName
        }
        cell.contentConfiguration = content
        return cell
    }
}

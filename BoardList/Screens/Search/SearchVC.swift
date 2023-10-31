//
//  SearchVC.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/27.
//

import UIKit
import Combine

final class SearchVC: UIViewController {
    private let viewModel: SearchVM
    private var subscriptions = Set<AnyCancellable>()
    private let searchController = UISearchController()
    private let boardName: String
    private lazy var recentSearchTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = Theme.Color.bg
        table.dataSource = self
        table.delegate = self
        table.register(RecentSearchCell.self, forCellReuseIdentifier: RecentSearchCell.identifier)
        let backgroundView = CustomEmptyView()
        backgroundView.configure(type: .noRecentSearch)
        table.backgroundView = backgroundView
        table.tag = 1
        return table
    }()
    private lazy var searchResultTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = Theme.Color.bg
        table.dataSource = self
        table.delegate = self
        table.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        let backgroundView = CustomEmptyView()
        backgroundView.configure(type: .noSearchResult)
        table.backgroundView = backgroundView
        table.separatorStyle = .none
        table.tag = 2
        return table
    }()
    private lazy var searchCategoryTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = Theme.Color.bg
        table.dataSource = self
        table.delegate = self
        table.register(SearchCategoryCell.self, forCellReuseIdentifier: SearchCategoryCell.identifier)
        table.tag = 3
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configSearchBar()
        configViews()
        bind()
    }

    init(boardId: Int, boardName: String) {
        self.boardName = boardName
        viewModel = SearchVM(boardId: boardId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchVC {
    private func configSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.placeholder = "\(boardName)에서 검색"
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.setHidesBackButton(true, animated:true)
    }
    private func configViews() {
        searchResultTable.isHidden = true
        searchCategoryTable.isHidden = true
        
        [recentSearchTable, searchResultTable, searchCategoryTable].forEach {
            view.addSubview($0)
        }
        recentSearchTable.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16.0)
            $0.leading.trailing.equalToSuperview()
        }
        searchResultTable.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16.0)
            $0.leading.trailing.equalToSuperview()
        }
        searchCategoryTable.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16.0)
            $0.leading.trailing.equalToSuperview()
        }
    }
    private func bind() {
        viewModel.searchedDatas
            .receive(on: RunLoop.main)
            .sink { [unowned self] datas in
                guard let datas = datas else { return }
                if datas.count > 0 {
                    self.recentSearchTable.backgroundView?.isHidden = true
                } else {
                    self.recentSearchTable.backgroundView?.isHidden = false
                }
                self.recentSearchTable.reloadData()
            }.store(in: &subscriptions)
        
        viewModel.results
            .receive(on: RunLoop.main)
            .sink { [unowned self] results in
                guard let results = results else { return }
                self.recentSearchTable.isHidden = true
                self.searchCategoryTable.isHidden = true
                self.searchResultTable.isHidden = false
                if results.count > 0 {
                    self.searchResultTable.backgroundView?.isHidden = true
                } else {
                    self.searchResultTable.backgroundView?.isHidden = false
                }
                self.searchResultTable.reloadData()
            }.store(in: &subscriptions)
        
        viewModel.currentKeyword
            .receive(on: RunLoop.main)
            .sink { [unowned self] keyword in
                // 현재 입력중인 키워드가 빈문자열이면 (= searchBar에서 지우기 버튼을 누른상황)
                // 검색내역(recentSearchTable)을 다시 보여주고 나머지 테이블들을 숨긴다
                // searchBarTextDidEndEditing에서 해당로직을 실행하면 실행되지가 않아서 여기에 코드를 작성함.
                if keyword.isEmpty {
                    self.searchCategoryTable.isHidden = true
                    self.searchResultTable.isHidden = true
                    self.recentSearchTable.isHidden = false
                    // 변경된 검색내역을 업데이트하는 코드
                    viewModel.fetchSearchedData()
                    self.recentSearchTable.reloadData()
                }
                self.searchCategoryTable.reloadData()
            }.store(in: &subscriptions)
    }
    private func hideKeyboard() {
        searchController.searchBar.resignFirstResponder()
    }
}

extension SearchVC: RecentSearchCellDelegate {
    func didTapDelete(searchedDataId: String) {
        viewModel.deleteSearchedData(id: searchedDataId)
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        recentSearchTable.isHidden = true
        if let text = searchBar.text {
            viewModel.search(text, searchTarget: .all)
        }
        hideKeyboard()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        recentSearchTable.isHidden = true
        searchCategoryTable.isHidden = false
        viewModel.currentKeyword.send(searchText)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.currentKeyword.send("")
        hideKeyboard()
    }
    
    
}

extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 2 {
            return 74
        } else {
            return 56
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            if let data = viewModel.searchedDatas.value?[indexPath.row] {
                searchController.searchBar.text = data.keyword
                if let searchTarget = SearchTarget(rawValue: data.category) {
                    viewModel.fetchResults(data.keyword, searchTarget: searchTarget)
                } else {
                    print("Decoding Error - rawValue to enum ")
                }
            }
        }
        if tableView.tag == 3 {
            let target = SearchTarget.allCases[indexPath.row]
            viewModel.search(viewModel.currentKeyword.value, searchTarget: target)
        }
    }
}

extension SearchVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return viewModel.searchedDatas.value?.count ?? 0
        }
        if tableView.tag == 2 {
            return viewModel.results.value?.count ?? 0
        }
        if tableView.tag == 3 {
            return SearchTarget.allCases.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.identifier, for: indexPath) as? RecentSearchCell
            if let data = viewModel.searchedDatas.value?[indexPath.row] {
                cell?.configure(data: data)
                cell?.delegate = self
                cell?.selectionStyle = .none
            }
            return cell ?? UITableViewCell()
        }
        
        if tableView.tag == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell
            if let post = viewModel.results.value?[indexPath.row] {
                cell?.configure(post: post)
                cell?.selectionStyle = .none
            }
            return cell ?? UITableViewCell()
        }
        
        if tableView.tag == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchCategoryCell.identifier, for: indexPath) as? SearchCategoryCell
            let target = SearchTarget.allCases[indexPath.row]
            cell?.configure(target: target, keyword: viewModel.currentKeyword.value)
            cell?.selectionStyle = .none
            return cell ?? UITableViewCell()
        }
        
        return UITableViewCell()
    }
}

//
//  SearchViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/7/24.
//

import UIKit
import SnapKit
import Kingfisher

class SearchViewController: BaseViewController {
    var selectName: ((String) -> Void)?
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "영양제를 검색해보세요..."
        return searchBar
    }()
    
    private lazy var searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        bindData()
    }
    
    func bindData() {
        viewModel.outputSupplement.bind { _ in
            self.searchTableView.reloadData()
        }
        
        viewModel.outputName.bind { [weak self] value in
            guard let value = value else { return }
            self?.selectName?(value)
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(searchTableView)
    }
    
    override func configureConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SearchViewController {
    private func setNav() {
        navigationItem.title = "Search"
        navigationController?.navigationBar.tintColor = .systemOrange
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(rightBarButtonItemClikced))
    }
    
    @objc private func rightBarButtonItemClikced() {
        dismiss(animated: true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputSupplement.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as! SearchResultTableViewCell
        let row = indexPath.row
        let data = viewModel.outputSupplement.value[row]
        let searchText = viewModel.inputUpdateSearchResults.value ?? ""
        cell.configureCell(data, searchText: searchText)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.inputName.value = viewModel.outputSupplement.value[indexPath.row].prdlstNm
        dismiss(animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.inputUpdateSearchResults.value = (searchBar.text)
    }
}

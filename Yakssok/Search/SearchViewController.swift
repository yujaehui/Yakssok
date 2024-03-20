//
//  SearchViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/7/24.
//

import UIKit
import SnapKit
import Kingfisher
import Toast

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
        tableView.prefetchDataSource = self
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private let EmptyLabel: UILabel = {
       let label = UILabel()
        label.text = "검색하신 영양제를 찾지 못했어요."
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        bindData()
    }
    
    func bindData() {
        viewModel.outputRow.bind { value in
            print("!!!")
            self.searchTableView.reloadData()
            if !value.isEmpty && self.viewModel.inputStart.value == 1 {
                self.searchTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
        
        viewModel.outputName.bind { [weak self] value in
            guard let value = value else { return }
            self?.selectName?(value)
        }
        
        viewModel.outputEmpty.bind { [weak self] value in
            self?.searchTableView.isHidden = value
            self?.EmptyLabel.isHidden = !value
        }
        
        viewModel.outputShowToast.bind { [weak self] value in
            value ? self?.view.makeToastActivity(.center) : self?.view.hideToastActivity()
        }
        
        viewModel.outputError.bind { [weak self] value in
            guard let value = value else { return }
            var style = ToastStyle()
            style.backgroundColor = .systemOrange
            style.messageAlignment = .center
            style.messageFont = .boldSystemFont(ofSize: 18)
            self?.view.makeToast(value, duration: 5, position: .center, style: style)
        
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(searchTableView)
        view.addSubview(EmptyLabel)
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
        
        EmptyLabel.snp.makeConstraints { make in
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

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputRow.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as! SearchResultTableViewCell
        let row = indexPath.row
        let data = viewModel.outputRow.value[row]
        let searchText = viewModel.inputUpdateSearchResults.value ?? ""
        cell.configureCell(data, searchText: searchText)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.inputName.value = Helpers.shared.changeSearchResultText(viewModel.outputRow.value[indexPath.row].prdlstNm, changeText: "").string
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            if viewModel.outputRow.value.count - 3 == item.row && viewModel.outputEnd.value != item.row {
                print("지금!")
                viewModel.inputStart.value += 30
                if viewModel.outputTotalCount.value != "0" {
                    self.viewModel.inputUpdateSearchResults.value = self.searchBar.text
                } else {
                    print("페이지네이션 종료")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        //print("cancel prefetch \(indexPaths)")
    }
    
}

extension SearchViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            EmptyLabel.isHidden = true
//            searchTableView.isHidden = true
//        }
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputStart.value = 1
        viewModel.inputUpdateSearchResults.value = (searchBar.text)
        searchBar.resignFirstResponder()
    }
}

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
    let searchTableView = UITableView()
    
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
    }
    
    override func configureHierarchy() {
        view.addSubview(searchTableView)
    }
    
    override func configureView() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        searchTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func configureConstraints() {
        searchTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setNav() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.title = "Search"
        navigationItem.backButtonTitle = ""
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
        let vc = AddViewController()
        vc.viewModel.inputSupplement.value = viewModel.outputSupplement.value[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.inputUpdateSearchResults.value = (searchController.searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.outputSupplement.value.removeAll()
    }
}

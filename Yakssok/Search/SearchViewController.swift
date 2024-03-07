//
//  SearchViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/7/24.
//

import UIKit
import SnapKit

class SearchViewController: BaseViewController {
    lazy var searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureUICollectionView())
    
    let viewModel = SearchViewModel()
    
    private func configureUICollectionView() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let cellWidth = UIScreen.main.bounds.width - (spacing * 3)
        layout.itemSize = CGSize(width: cellWidth / 2, height: cellWidth / 2)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        return layout
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        bindData()
    }
    
    func bindData() {
        viewModel.outputUpdateSearchResults.bind { success in
            self.searchCollectionView.reloadData()
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(searchCollectionView)
    }
    
    override func configureView() {
        searchCollectionView.backgroundColor = .systemGray
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
    }
    
    override func configureConstraints() {
        searchCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setNav() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Search"
        navigationItem.backButtonTitle = ""
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputUpdateSearchResults.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        let item = indexPath.item
        let data = viewModel.outputUpdateSearchResults.value[item]
        cell.resultBrandLabel.text = data.bsshNm
        cell.resultNameLabel.text = data.prdlstNm
        return cell
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.inputUpdateSearchResults.value = (searchController.searchBar.text)
    }
}

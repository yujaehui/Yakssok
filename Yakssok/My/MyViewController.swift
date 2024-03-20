//
//  MyViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/16/24.
//

import UIKit
import SnapKit

enum MySection: CaseIterable {
    case main
}

class MyViewController: BaseViewController {
    
    let viewModel = MyViewModel()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        return collectionView
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<MySection, MySupplement>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureDataSource()
        updateSnapshot()
    }
    
    func setNav() {
        navigationItem.title = "My"
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(rightBarButtonItemClikced))
    }
    
    @objc private func rightBarButtonItemClikced() {
        let vc = AddViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureDataSource() {
        let cellRegistration = cellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<MySection, MySupplement>()
        snapshot.appendSections(MySection.allCases)
        snapshot.appendItems(viewModel.repository.fetchAllItem(), toSection: .main)
        dataSource.apply(snapshot)
    }
}

extension MyViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func cellRegistration() -> UICollectionView.CellRegistration<MyCollectionViewCell, MySupplement> {
        UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.configureCell(itemIdentifier)
        }
    }
}

extension MyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let vc = AddViewController()
        vc.viewModel.inputType.value = .update
        vc.viewModel.inputMySupplement.value = viewModel.repository.fetchAllItem()[row]
        vc.viewModel.inputMySupplements.value = viewModel.repository.fetchItmes(name: viewModel.repository.fetchAllItem()[row].name)
        navigationController?.pushViewController(vc, animated: true)
    }
}

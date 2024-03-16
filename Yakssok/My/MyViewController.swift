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
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    var dataSource: UICollectionViewDiffableDataSource<MySection, MySupplement>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        updateSnapshot()
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func configureView() {
        collectionView.delegate = self
    }
    
    override func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func cellRegistration() -> UICollectionView.CellRegistration<MyCollectionViewCell, MySupplement> {
        UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.configureCell(itemIdentifier)
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
        snapshot.appendItems(viewModel.repository.fetchItem(), toSection: .main)
        dataSource.apply(snapshot)
    }
}

extension MyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let vc = AddViewController()
        vc.viewModel.inputName.value = viewModel.repository.fetchItem()[row].name
        vc.viewModel.inputAmount.value = viewModel.repository.fetchItem()[row].amout
        vc.viewModel.inputStartDay.value = viewModel.repository.fetchItem()[row].startDay
        vc.viewModel.inputCycle.value = viewModel.repository.fetchItem()[row].cycleArray
        vc.viewModel.inputTimeList.value = viewModel.repository.fetchItem()[row].timeArray
        navigationController?.pushViewController(vc, animated: true)
    }
}

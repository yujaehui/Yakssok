//
//  SearchDetailViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit
import SnapKit

enum SectionType: String, CaseIterable {
    case name = "영양제 이름"
    case amount = "복용량"
    case startDay = "복용시작일"
    case cycle = "복용주기"
    case time = "복용시간"
}

final class SearchDetailViewController: BaseViewController {
    
    let viewModel = SearchDetailViewModel()
        
    // MARK: - 1. Property
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureUICollectioViewLayout())
    var dataSource: UICollectionViewDiffableDataSource<SectionType, String>!
    
    deinit {
        print("SearchDetailViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SearchDetailViewController viewDidLoad")
        configureHierarchy()
        configureConstraints()
        
        configureDataSource()
        updateSnapshot()
        bindData()

    }
    
    func bindData() {
        viewModel.outputSupplement.bind { [weak self] _ in
            self?.updateSnapshot()
        }
        
        viewModel.outputTimeList.bind { [weak self] value in
            self?.updateSnapshot()
        }
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
    
    // MARK: - 2. Layout : Flow -> Compositional(ListConfiguration)
    private func configureUICollectioViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    // MARK: - 3. CellRegistration, DataSource
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.subtitleCell()
            content.text = itemIdentifier
            content.textProperties.alignment = .center
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    // MARK: - 4. Snapshot
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, String>()
        snapshot.appendSections(SectionType.allCases)
        snapshot.appendItems([viewModel.outputSupplement.value.prdlstNm], toSection: .name)
        snapshot.appendItems(["amount"], toSection: .amount)
        snapshot.appendItems(["startDay"], toSection: .startDay)
        snapshot.appendItems(["cycle"], toSection: .cycle)
        snapshot.appendItems(viewModel.outputTimeList.value, toSection: .time)
        dataSource.apply(snapshot)
        
    }
}

extension SearchDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch SectionType.allCases[indexPath.section] {
        case .name: print("name")
        case .amount: print("amount")
        case .startDay: print("startDay")
        case .cycle: print("cycle")
        case .time:
            let vc = TimeSettingViewController()
            vc.viewModel.inputTimeList.value = viewModel.outputTimeList.value
            vc.selectTimeList = { [weak self] value in
                self?.viewModel.inputTimeList.value = value
            }
            let nav = UINavigationController(rootViewController: vc)
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            present(nav, animated: true)
        }
    }
}

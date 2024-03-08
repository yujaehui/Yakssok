//
//  SearchResultDetailViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/8/24.
//

import UIKit
import SnapKit

enum SectionType: String, CaseIterable {
    case Description
    case StartDay
    case Cycle
    case Time
    
    func makeSection() -> Section {
        switch self {
        case .Description: return DescriptionSection()
        case .StartDay: return StartDaySection()
        case .Cycle: return CycleSection()
        case .Time: return TimeSection()
        }
    }
}

class SearchResultDetailViewController: BaseViewController {
    
    var list = ["a", "b", "c"]
    
    lazy var collectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            SectionType.allCases[sectionIndex].makeSection().layoutSection()
        }
        return layout
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.dataSource = self
        view.delegate = self
        view.register(DescriptionCollectionViewCell.self, forCellWithReuseIdentifier: DescriptionCollectionViewCell.identifier)
        view.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: DateCollectionViewCell.identifier)
        view.register(TimeCollectionViewCell.self, forCellWithReuseIdentifier: TimeCollectionViewCell.identifier)
        view.register(TitleCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionReusableView.identifier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func configureView() {
        
    }
    
    override func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SearchResultDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleCollectionReusableView.identifier, for: indexPath) as! TitleCollectionReusableView
        header.titleLabel.text = SectionType.allCases[indexPath.section].rawValue
        switch SectionType.allCases[indexPath.section] {
        case .Description:
            header.addButton.isHidden = true
        case .StartDay:
            header.addButton.isHidden = true
        case .Cycle:
            header.addButton.isHidden = true
        case .Time:
            header.addButton.isHidden = false
            header.buttonAction = {
                self.list.append("d")
                collectionView.reloadData()
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch SectionType.allCases[section] {
        case .Description: return 1
        case .StartDay: return 1
        case .Cycle: return 1
        case .Time: return list.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch SectionType.allCases[indexPath.section] {
        case .Description:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescriptionCollectionViewCell.identifier, for: indexPath) as! DescriptionCollectionViewCell
            return cell
        case .StartDay:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.identifier, for: indexPath) as! DateCollectionViewCell
            return cell
        case .Cycle:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.identifier, for: indexPath) as! DateCollectionViewCell
            return cell
        case .Time:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeCollectionViewCell.identifier, for: indexPath) as! TimeCollectionViewCell
            cell.resultLabel.text = list[indexPath.row]
            return cell
        }
    }
}

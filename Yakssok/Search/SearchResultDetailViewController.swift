//
//  SearchResultDetailViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/8/24.
//

import UIKit
import SnapKit

enum SectionType: String, CaseIterable {
    case Name = "영양제 이름"
    case Amount = "복용량"
    case StartDay = "복용시작일"
    case Cycle = "복용주기"
    case Time = "복용시간"
    case Button
    
    func makeSection() -> Section {
        switch self {
        case .Name: return NameSection()
        case .Amount: return AmountSection()
        case .StartDay: return StartDaySection()
        case .Cycle: return CycleSection()
        case .Time: return TimeSection()
        case .Button: return ButtonSection()
        }
    }
}

class SearchResultDetailViewController: BaseViewController {
    
    var list = ["a"]
    
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
        view.register(SearchResultNameCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultNameCollectionViewCell.identifier)
        view.register(AmountCollectionViewCell.self, forCellWithReuseIdentifier: AmountCollectionViewCell.identifier)
        view.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: DateCollectionViewCell.identifier)
        view.register(TimeCollectionViewCell.self, forCellWithReuseIdentifier: TimeCollectionViewCell.identifier)
        view.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: ButtonCollectionViewCell.identifier)
        view.register(TitleCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionReusableView.identifier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        setToolBar()
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
    
    func setNav() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "복용 영양제 등록"
        navigationItem.backButtonTitle = ""
    }
    
    func setToolBar() {
        navigationController?.isToolbarHidden = false
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let addButton = UIBarButtonItem(title: "영양제 등록", style: .plain, target: self, action: #selector(registrationButtonClicked))
        let barItems = [flexibleSpace, addButton, flexibleSpace]
        self.toolbarItems = barItems
    }
    
    @objc func registrationButtonClicked() {
        print(#function)
    }
}

extension SearchResultDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleCollectionReusableView.identifier, for: indexPath) as! TitleCollectionReusableView
        header.titleLabel.text = SectionType.allCases[indexPath.section].rawValue
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch SectionType.allCases[section] {
        case .Time: return list.count
        default: return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch SectionType.allCases[indexPath.section] {
        case .Name:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultNameCollectionViewCell.identifier, for: indexPath) as! SearchResultNameCollectionViewCell
            return cell
        case .Amount:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AmountCollectionViewCell.identifier, for: indexPath) as! AmountCollectionViewCell
            return cell
        case .StartDay, .Cycle:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.identifier, for: indexPath) as! DateCollectionViewCell
            return cell
        case .Time:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeCollectionViewCell.identifier, for: indexPath) as! TimeCollectionViewCell
            cell.resultLabel.text = list[indexPath.row]
            return cell
        case .Button:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.identifier, for: indexPath) as! ButtonCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch SectionType.allCases[indexPath.section] {
        case .Button: buttonSectionClicked()
        default: break
        }
    }
    
    func buttonSectionClicked() {
        self.list.append("a")
        collectionView.reloadData()
    }
}

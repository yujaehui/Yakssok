//
//  CycleViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/10/24.
//

import UIKit
import SnapKit

enum DayOfTheWeek: String, CaseIterable {
    case sunday = "일"
    case monday = "월"
    case tuesday = "화"
    case wednesday = "수"
    case thursday = "목"
    case friday = "금"
    case saturday = "토"
}

class CycleViewController: BaseViewController {
    var selectDayOfTheWeek: (([String]) -> Void)?
    
    let viewModel = CycleViewModel()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CycleCollectionViewCell.self, forCellWithReuseIdentifier: CycleCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var registrationButton: UIButton = {
       let button = UIButton()
        button.configuration = .registration(title: "등록")
        button.addTarget(self, action: #selector(registrationButtonClicked), for: .touchUpInside)
        return button
    }()
    
    deinit {
        print("CycleViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CycleViewController viewDidLoad")
        setNav()
        bindData()
    }
    
    func bindData() {
        viewModel.outputIsSelected.bind { value in
            self.registrationButton.configuration?.baseBackgroundColor = value ? ColorStyle.point : ColorStyle.grayBackground
            self.registrationButton.isUserInteractionEnabled = value
        }
        
        viewModel.outputSelectDayOfTheWeekList.bind { [weak self] value in
            self?.collectionView.reloadData()
        }
        
        viewModel.outputDayOfTheWeekList.bind { [weak self] value in
            guard let value = value else { return }
            self?.selectDayOfTheWeek?(value)
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(registrationButton)
    }
    
    override func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.center.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        registrationButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }
    
    @objc private func registrationButtonClicked() {
        viewModel.inputDayOfTheWeekList.value = viewModel.outputSelectDayOfTheWeekList.value
        dismiss(animated: true)
    }
}

extension CycleViewController {
    private func setNav() {
        navigationController?.navigationBar.tintColor = ColorStyle.point
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(rightBarButtonItemClikced))
    }
    
    @objc private func rightBarButtonItemClikced() {
        dismiss(animated: true)
    }
}

extension CycleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 12
        let cellWidth = UIScreen.main.bounds.width - (spacing * 8)
        layout.itemSize = CGSize(width: cellWidth / 7, height: cellWidth / 7)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DayOfTheWeek.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CycleCollectionViewCell.identifier, for: indexPath) as! CycleCollectionViewCell
        let week = viewModel.outputSelectDayOfTheWeekList.value
        let day = DayOfTheWeek.allCases[indexPath.item].rawValue
        cell.configureCell(week: week, day: day)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.inputSelectDayOfTheWeek.value = DayOfTheWeek.allCases[indexPath.item].rawValue
    }
}


//
//  DayOfTheWeekViewController.swift
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

class DayOfTheWeekViewController: BaseViewController {
    var selectDayOfTheWeek: (([String]) -> Void)?
    
    let viewModel = DayOfTheWeekViewModel()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    let registrationButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DayOfTheWeekViewController viewDidLoad")
        bindData()
    }
    
    deinit {
        print("DayOfTheWeekViewController deinit")
    }
    
    func bindData() {
        viewModel.outputColor.bind { value in
            self.registrationButton.backgroundColor = value ? .systemBlue : .systemGray
        }
        
        viewModel.outputIsEnabled.bind { value in
            self.registrationButton.isEnabled = value
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
    
    override func configureView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DayOfTheWeekCollectionViewCell.self, forCellWithReuseIdentifier: DayOfTheWeekCollectionViewCell.identifier)
        
        registrationButton.setTitle("등록", for: .normal)
        registrationButton.backgroundColor = .lightGray
        registrationButton.addTarget(self, action: #selector(registrationButtonClicked), for: .touchUpInside)
    }
    
    @objc func registrationButtonClicked() {
        viewModel.inputDayOfTheWeekList.value = viewModel.outputSelectDayOfTheWeekList.value
        dismiss(animated: true)
    }
    
    override func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.center.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        
        registrationButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
    }
}

extension DayOfTheWeekViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayOfTheWeekCollectionViewCell.identifier, for: indexPath) as! DayOfTheWeekCollectionViewCell
        cell.dayLabel.text = DayOfTheWeek.allCases[indexPath.item].rawValue
        
        if viewModel.outputSelectDayOfTheWeekList.value.contains(where: {$0 == DayOfTheWeek.allCases[indexPath.item].rawValue}) {
            cell.dayLabel.backgroundColor = .red
        } else {
            cell.dayLabel.backgroundColor = .blue
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.inputSelectDayOfTheWeek.value = DayOfTheWeek.allCases[indexPath.item].rawValue
    }
    
}


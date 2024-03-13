//
//  CalendarViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/11/24.
//

import UIKit
import SnapKit
import FSCalendar

final class CalendarViewController: BaseViewController {
    
    let viewModel = CalendarViewModel()
    
    enum Section: CaseIterable {
        case main
    }
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = DateFormatterManager.shared.makeHeaderDateFormatter(date: Date())
        return label
    }()
    
    private lazy var toggleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        button.addTarget(self, action: #selector(tapToggleButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.placeholderType = .none
        calendar.appearance.headerTitleColor = .clear
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        return calendar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureUICollectioViewLayout())
        return collectionView
    }()
    
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, MySupplement>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        updateSnapshot()
        bindData()
    }
    
    func bindData() {
        viewModel.outputMySupplement.bind { [weak self] value in
            guard let self = self else { return }
            print(value)
            self.updateSnapshot()
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(headerLabel)
        view.addSubview(toggleButton)
        view.addSubview(calendar)
        view.addSubview(collectionView)
    }
    
    override func configureConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(32)
        }
        
        toggleButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(32)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(300)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureUICollectioViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MySupplement> { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.subtitleCell()
            content.text = itemIdentifier.name
            content.textProperties.alignment = .center
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MySupplement>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(viewModel.outputMySupplement.value, toSection: .main)
        dataSource.apply(snapshot)
    }
    
    @objc private func tapToggleButton() {
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
            self.toggleButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            self.headerLabel.text = DateFormatterManager.shared.makeHeaderDateFormatter(date: calendar.selectedDate ?? calendar.currentPage)
        } else {
            self.calendar.setScope(.month, animated: true)
            self.toggleButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            self.headerLabel.text = DateFormatterManager.shared.makeHeaderDateFormatter(date: calendar.currentPage)
        }
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        headerLabel.text = DateFormatterManager.shared.makeHeaderDateFormatter(date: calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(DateFormatterManager.shared.dayOfWeek(from: date))
        viewModel.inputDidSelectTrigger.value = (date)
        
        if calendar.scope == .week {
            self.headerLabel.text = DateFormatterManager.shared.makeHeaderDateFormatter(date: date)
        } else {
            return
        }
    }
}

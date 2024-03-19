//
//  AddViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit
import SnapKit
import RealmSwift

enum Section: String, CaseIterable {
    case image = "영양제 이미지"
    case name = "영양제 이름"
    case amount = "복용량"
    case startDay = "복용시작일"
    case period = "복용기간"
    case cycle = "복용요일"
    case time = "복용시간"
}

struct SectionItem: Hashable {
    let section: Section
    let image: UIImage?
    let item: String
}

final class AddViewController: BaseViewController {
    
    let viewModel = AddViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, SectionItem>!
    
    deinit {
        print("AddViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddViewController viewDidLoad")
        setNav()
        setToolBar()
        configureDataSource()
        updateSnapshot()
        bindData()
    }
    
    private func bindData() {
        viewModel.outputType.bind { [weak self] _ in
            self?.updateSnapshot()
        }
        
        viewModel.outputImage.bind { [weak self] value in
            self?.updateSnapshot()
        }
        
        viewModel.outputStartDayString.bind { [weak self] value in
            self?.updateSnapshot()
        }
        
        viewModel.outputPeriodString.bind { [weak self] value in
            self?.updateSnapshot()
        }
        
        viewModel.outputCycleString.bind { [weak self] value in
            self?.updateSnapshot()
        }
        
        viewModel.outputTimeListString.bind { [weak self] value in
            self?.updateSnapshot()
        }
        
        viewModel.presentSearchVC.bind { [weak self] value in
            guard let _ = value else { return }
            let vc = SearchViewController()
            vc.selectName = { value in
                self?.viewModel.inputName.value = value
                self?.updateSnapshot()
            }
            let nav = UINavigationController(rootViewController: vc)
            self?.present(nav, animated: true)
        }
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
        let imageCellRegistration = imageCellRegistration()
        let nameCellRegistration = nameCellRegistration()
        let amountCellRegistration = amoutCellRegistration()
        let cellRegistration = commonCellRegistration()
        let headerRegistration = headerRegistration()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch Section.allCases[indexPath.section] {
            case .image:
                let cell = collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration, for: indexPath, item: itemIdentifier)
                return cell
            case .name:
                let cell = collectionView.dequeueConfiguredReusableCell(using: nameCellRegistration, for: indexPath, item: itemIdentifier)
                return cell
            case .amount:
                let cell = collectionView.dequeueConfiguredReusableCell(using: amountCellRegistration, for: indexPath, item: itemIdentifier)
                return cell
            default:
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
                return cell
            }
            
        })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            } else {
                return nil
            }
        }
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([SectionItem(section: .image, image: viewModel.outputImage.value, item: "")], toSection: .image)
        snapshot.appendItems([SectionItem(section: .name, image: nil, item: viewModel.outputName.value)], toSection: .name)
        snapshot.appendItems([SectionItem(section: .amount, image: nil, item: viewModel.outputAmountString.value)], toSection: .amount)
        snapshot.appendItems([SectionItem(section: .startDay, image: nil, item: viewModel.outputStartDayString.value)], toSection: .startDay)
        snapshot.appendItems([SectionItem(section: .period, image: nil, item: viewModel.outputPeriodString.value)], toSection: .period)
        snapshot.appendItems([SectionItem(section: .cycle, image: nil, item: viewModel.outputCycleString.value)], toSection: .cycle)
        snapshot.appendItems(viewModel.outputTimeListString.value.map { SectionItem(section: .time, image: nil, item: $0) }, toSection: .time)
        dataSource.apply(snapshot)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension AddViewController {
    private func setNav() {
        switch viewModel.outputType.value {
        case .create: return
        case .update:
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(rightBarButtonItemClikced))
        }
    }
    
    @objc private func rightBarButtonItemClikced() {
        viewModel.deleteTrigger.value = ()
        navigationController?.popViewController(animated: true)
    }
    
    private func setToolBar() {
        navigationController?.isToolbarHidden = false
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let registrationButton = UIBarButtonItem(title: viewModel.outputType.value.rawValue, style: .plain, target: self, action: #selector(registrationButtonClicked))
        let barItems = [flexibleSpace, registrationButton, flexibleSpace]
        self.toolbarItems = barItems
    }
    
    @objc private func registrationButtonClicked() {
        switch viewModel.outputType.value {
        case .create:
            viewModel.createTrigger.value = ()
            navigationController?.popViewController(animated: true)
        case .update:
            viewModel.updateTrigger.value = ()
            navigationController?.popViewController(animated: true)
        }
    }
}

extension AddViewController {
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.backgroundColor = .white
        config.headerMode = .supplementary
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func headerRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        UICollectionView.SupplementaryRegistration(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, string, indexPath in
            var headerConfig = UIListContentConfiguration.groupedHeader()
            headerConfig.text = Section.allCases[indexPath.section].rawValue
            headerConfig.textProperties.font = .boldSystemFont(ofSize: 18)
            supplementaryView.contentConfiguration = headerConfig
        }
    }
    
    private func imageCellRegistration() -> UICollectionView.CellRegistration<ImageCollectionViewCell, SectionItem> {
        UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.configureCell(itemIdentifier)
        }
    }
    
    private func nameCellRegistration() -> UICollectionView.CellRegistration<NameCollectionViewCell, SectionItem> {
        UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.configureCell(itemIdentifier)
            cell.passMoment = {
                self.viewModel.presentSearchVC.value = ()
            }
            cell.passName = { value in
                self.viewModel.inputName.value = value
            }
        }
    }
    
    private func amoutCellRegistration() -> UICollectionView.CellRegistration<AmountCollectionViewCell, SectionItem> {
        UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.configureCell(itemIdentifier)
            cell.passAmount = { value in
                self.viewModel.inputAmount.value = value
            }
        }
    }
    
    private func commonCellRegistration() -> UICollectionView.CellRegistration<CommonCollectionViewCell, SectionItem> {
        UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.configureCell(itemIdentifier)
        }
    }
}

extension AddViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewModel.outputType.value {
        case .create:
            switch Section.allCases[indexPath.section] {
            case .image:
                let vc = ImageTypeSelectViewController()
                vc.viewModel.inputCurrentImage.value = viewModel.outputCurrentImage.value
                vc.passImage = { [weak self] value in
                    self?.viewModel.inputImage.value = value
                }
                let nav = UINavigationController(rootViewController: vc)
                if let sheet = nav.sheetPresentationController {
                    sheet.detents = [.medium()]
                }
                present(nav, animated: true)
            case .name: return
            case .amount: return
            case .startDay:
                let vc = StartDaySettingViewController()
                vc.viewModel.outputDate.value = viewModel.inputStartDay.value
                vc.selectDate = { [weak self] value in
                    self?.viewModel.inputStartDay.value = value
                }
                
                let nav = UINavigationController(rootViewController: vc)
                if let sheet = nav.sheetPresentationController {
                    sheet.detents = [.medium()]
                }
                present(nav, animated: true)
            case .period:
                let vc = PeriodViewController()
                vc.viewModel.outputPeriod.value = viewModel.inputPeriod.value
                vc.selectPeriod = { [weak self] value in
                    self?.viewModel.inputPeriod.value = value
                }
                let nav = UINavigationController(rootViewController: vc)
                if let sheet = nav.sheetPresentationController {
                    sheet.detents = [.medium()]
                }
                present(nav, animated: true)
            case .cycle:
                let vc = CycleViewController()
                vc.viewModel.outputSelectDayOfTheWeekList.value = viewModel.inputCycle.value
                vc.selectDayOfTheWeek = { [weak self] value in
                    self?.viewModel.inputCycle.value = value
                }
                let nav = UINavigationController(rootViewController: vc)
                if let sheet = nav.sheetPresentationController {
                    sheet.detents = [.medium()]
                }
                present(nav, animated: true)
            case .time:
                let vc = TimeSettingViewController()
                vc.viewModel.outputSelectTimeList.value = viewModel.inputTimeList.value
                vc.selectTimeList = { [weak self] value in
                    self?.viewModel.inputTimeList.value = value
                }
                let nav = UINavigationController(rootViewController: vc)
                if let sheet = nav.sheetPresentationController {
                    sheet.detents = [.medium()]
                }
                present(nav, animated: true)
            }
        case .update:
            switch Section.allCases[indexPath.section] {
            case .image:
                let vc = ImageTypeSelectViewController()
                vc.viewModel.inputCurrentImage.value = viewModel.outputCurrentImage.value
                vc.passImage = { [weak self] value in
                    self?.viewModel.inputImage.value = value
                }
                let nav = UINavigationController(rootViewController: vc)
                if let sheet = nav.sheetPresentationController {
                    sheet.detents = [.medium()]
                }
                present(nav, animated: true)
            case .name: return
            case .amount: return
            default:
                print("수정 불가능한 항목") // 토스트
                return
            }
        }
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

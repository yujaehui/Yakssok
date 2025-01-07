//
//  AddViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit
import SnapKit
import RealmSwift
import Toast

enum Section: String, CaseIterable {
    case image = "영양제 이미지"
    case name = "영양제 이름"
    case amount = "1회 복용량"
    case stock = "총 보유량"
    case cycle = "복용 요일"
    case time = "복용 시간"
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
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.configuration = .registration(title: viewModel.outputType.value.rawValue)
        button.addTarget(self, action: #selector(registrationButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, SectionItem>!
    
    deinit {
        print("AddViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddViewController viewDidLoad")
        setNav()
        setTabBar()
        configureDataSource()
        updateSnapshot()
        bindData()
    }
    
    private func bindData() {
        viewModel.outputType.bind { [weak self] value in
            guard let self = self else { return }
            self.updateSnapshot()
        }
        
        viewModel.outputImage.bind { [weak self] value in
            guard let self = self else { return }
            self.updateSnapshot()
        }
        
        viewModel.outputStock.bind { [weak self] value in
            guard let self = self else { return }
            self.updateSnapshot()
        }
        
        viewModel.outputCycleListString.bind { [weak self] value in
            guard let self = self else { return }
            self.updateSnapshot()
        }
        
        viewModel.outputTimeListString.bind { [weak self] value in
            guard let self = self else { return }
            self.updateSnapshot()
        }
        
        viewModel.presentSearchVC.bind { [weak self] value in
            guard let self = self, let _ = value else { return }
            let vc = SearchViewController()
            vc.selectName = { name in
                self.viewModel.inputName.value = name
                self.updateSnapshot()
            }
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true)
        }
        
        viewModel.outputRegistrationStatus.bind { [weak self] value in
            guard let self = self, let value = value else { return }
            switch value {
            case .success:
                self.navigationController?.popViewController(animated: true)
            case .duplicateName, .noName:
                ToastManager.shared.showToast(title: value.rawValue, in: self.view ?? UIView())
            case .limitExceeded:
                let alert = AlertManager.shared.showWarningAlert(message: value.rawValue)
                self.present(alert, animated: true)
            }
        }
        
        viewModel.updateTrigger.bind { [weak self] value in
            guard let self = self, let _ = value else { return }
            let alert = AlertManager.shared.showAlert(
                title: "영양제를 수정하시겠습니까?",
                message: "",
                btnTitle: "수정"
            ) { _ in
                self.viewModel.updateButtonClicked.value = ()
                self.navigationController?.popViewController(animated: true)
            }
            self.present(alert, animated: true)
        }
        
        viewModel.deleteTrigger.bind { [weak self] value in
            guard let self = self, let  _ = value else { return }
            let alert = AlertManager.shared.showDestructiveAlert(
                title: "영양제를 삭제하시겠습니까?",
                message: "과거 복용 기록도 함께 삭제되며,\n이 작업은 되돌릴 수 없습니다."
            ) { _ in
                self.viewModel.deleteButtonClicked.value = ()
                self.navigationController?.popViewController(animated: true)
            }
            self.present(alert, animated: true)
        }
    }

    override func configureHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(registrationButton)
    }
    
    override func configureView() {
        view.backgroundColor = ColorStyle.grayBackground
    }
    
    override func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(registrationButton.snp.top)
        }
        
        registrationButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
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
        print(#function)
        var snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([SectionItem(section: .image, image: viewModel.outputImage.value, item: "")], toSection: .image)
        snapshot.appendItems([SectionItem(section: .name, image: nil, item: viewModel.outputName.value)], toSection: .name)
        snapshot.appendItems([SectionItem(section: .amount, image: nil, item: viewModel.outputAmountString.value)], toSection: .amount)
        snapshot.appendItems([SectionItem(section: .stock, image: nil, item: viewModel.outputStock.value)], toSection: .stock)
        snapshot.appendItems([SectionItem(section: .cycle, image: nil, item: viewModel.outputCycleListString.value)], toSection: .cycle)
        snapshot.appendItems(viewModel.outputTimeListString.value.map { SectionItem(section: .time, image: nil, item: $0) }, toSection: .time)
        dataSource.apply(snapshot)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func registrationButtonClicked() {
        switch viewModel.outputType.value {
        case .create:
            viewModel.createTrigger.value = ()
        case .update:
            viewModel.updateTrigger.value = ()
        }
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
    }
    
    private func setTabBar() {
        tabBarController?.tabBar.isHidden = true
    }
}

extension AddViewController {
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.backgroundColor = ColorStyle.grayBackground
        config.headerMode = .supplementary
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func headerRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        UICollectionView.SupplementaryRegistration(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, string, indexPath in
            var headerConfig = UIListContentConfiguration.groupedHeader()
            headerConfig.text = Section.allCases[indexPath.section].rawValue
            headerConfig.textProperties.font = FontStyle.titleBold
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
        switch Section.allCases[indexPath.section] {
        case .image:
            let vc = ImageTypeSelectViewController()
            vc.viewModel.inputCurrentImage.value = viewModel.outputCurrentImage.value
            vc.passImage = { [weak self] value in
                guard let self = self else { return }
                self.viewModel.inputImage.value = value
            }
            let nav = UINavigationController(rootViewController: vc)
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.customDetent {return 300}]
            }
            present(nav, animated: true)
        case .name: return
        case .amount: return
        case .stock:
            let vc = StockViewController()
            vc.viewModel.outputStock.value = viewModel.inputStock.value
            vc.selectStock = { [weak self] value in
                guard let self = self else { return }
                self.viewModel.inputStock.value = value
            }
            let nav = UINavigationController(rootViewController: vc)
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.customDetent {return 300}]
            }
            present(nav, animated: true)
        case .cycle:
            let vc = CycleViewController()
            vc.viewModel.outputSelectDayOfTheWeekList.value = viewModel.inputCycleList.value
            vc.selectDayOfTheWeek = { [weak self] value in
                guard let self = self else { return }
                self.viewModel.inputCycleList.value = value
            }
            let nav = UINavigationController(rootViewController: vc)
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.customDetent {return 300}]
            }
            present(nav, animated: true)
        case .time:
            let vc = TimeViewController()
            vc.viewModel.outputSelectTimeList.value = viewModel.inputTimeList.value
            vc.selectTimeList = { [weak self] value in
                guard let self = self else { return }
                self.viewModel.inputTimeList.value = value
            }
            let nav = UINavigationController(rootViewController: vc)
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            present(nav, animated: true)
        }
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

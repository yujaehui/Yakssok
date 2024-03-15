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
    case cycle = "복용주기"
    case time = "복용시간"
}

struct SectionItem: Hashable {
    let section: Section
    let image: UIImage?
    let item: String
}

final class AddViewController: BaseViewController {
    
    let viewModel = AddViewModel()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private var dataSource: UICollectionViewDiffableDataSource<Section, SectionItem>!
    
    private var image = UIImage(systemName: "pill.fill")
    
    deinit {
        print("AddViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddViewController viewDidLoad")
        setToolBar()
        configureDataSource()
        updateSnapshot()
        bindData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func bindData() {
        viewModel.outputSupplement.bind { [weak self] _ in
            self?.updateSnapshot()
        }
        
        viewModel.outputAmountString.bind { [weak self] value in
            self?.updateSnapshot()
        }
        
        viewModel.outputStartDayString.bind { [weak self] value in
            self?.updateSnapshot()
        }
        
        viewModel.outputCycleString.bind { [weak self] value in
            self?.updateSnapshot()
        }
        
        viewModel.outputTimeListString.bind { [weak self] value in
            self?.updateSnapshot()
        }
    }
    
    private func setToolBar() {
        navigationController?.isToolbarHidden = false
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let registrationButton = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(registrationButtonClicked))
        let barItems = [flexibleSpace, registrationButton, flexibleSpace]
        self.toolbarItems = barItems
    }
    
    @objc private func registrationButtonClicked() {
        let data = MySupplement(name: viewModel.outputName.value, amout: viewModel.outputAmount.value, startDay: viewModel.outputStartDay.value, cycleArray: viewModel.outputCycle.value, timeArray: viewModel.outputTimeList.value)
        viewModel.repository.createItem(data)
        if let image = image {
            saveImageToDocument(image: image, fileName: "\(data.pk)")
        }        
        //dismiss(animated: true)
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
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            let layoutSection: NSCollectionLayoutSection
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.interGroupSpacing = 5
            return layoutSection
        }
        return layout
    }
    
    private func imageCellRegistration() -> UICollectionView.CellRegistration<ImageCollectionViewCell, SectionItem> {
        UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.imageView.image = itemIdentifier.image
        }
    }
    
    private func nameCellRegistration() -> UICollectionView.CellRegistration<NameCollectionViewCell, SectionItem> {
        UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.configureCell(itemIdentifier)
            cell.passName = { value in
                self.viewModel.inputName.value = value
            }
        }
    }
    
    private func amoutCellRegistration() -> UICollectionView.CellRegistration<AmountCollectionViewCell, SectionItem> {
        UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.configureCell(itemIdentifier)
            cell.minusButtonAction = {
                self.viewModel.inputMinusAmount.value = self.viewModel.outputAmount.value
            }
            cell.plusButtonAction = {
                self.viewModel.inputPlusAmount.value = self.viewModel.outputAmount.value
            }
        }
    }
    
    private func commonCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, SectionItem> {
        UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.subtitleCell()
            content.text = itemIdentifier.item
            content.textProperties.alignment = .center
            cell.contentConfiguration = content
        }
    }
    
    private func configureDataSource() {
        let imageCellRegistration = imageCellRegistration()
        let nameCellRegistration = nameCellRegistration()
        let amountCellRegistration = amoutCellRegistration()
        let cellRegistration = commonCellRegistration()

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
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([SectionItem(section: .image, image: image, item: "")], toSection: .image)
        snapshot.appendItems([SectionItem(section: .name, image: nil, item: viewModel.outputName.value)], toSection: .name)
        snapshot.appendItems([SectionItem(section: .amount, image: nil, item: viewModel.outputAmountString.value)], toSection: .amount)
        snapshot.appendItems([SectionItem(section: .startDay, image: nil, item: viewModel.outputStartDayString.value)], toSection: .startDay)
        snapshot.appendItems([SectionItem(section: .cycle, image: nil, item: viewModel.outputCycleString.value)], toSection: .cycle)
        snapshot.appendItems(viewModel.outputTimeListString.value.map { SectionItem(section: .time, image: nil, item: $0) }, toSection: .time)
        dataSource.apply(snapshot)
        
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
            vc.selectImage = { value in
                self.image = value
                self.updateSnapshot()
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
        case .cycle:
            let vc = DayOfTheWeekViewController()
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
    }
}

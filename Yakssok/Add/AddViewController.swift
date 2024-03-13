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
    case name = "영양제 이름"
    case amount = "복용량"
    case startDay = "복용시작일"
    case cycle = "복용주기"
    case time = "복용시간"
}

final class AddViewController: BaseViewController {
    
    let viewModel = AddViewModel()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureUICollectioViewLayout())
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    deinit {
        print("AddViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddViewController viewDidLoad")
        configureHierarchy()
        configureConstraints()
        configureDataSource()
        
        setToolBar()
        
        updateSnapshot()
        bindData()
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
    
    private func configureUICollectioViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    private func configureDataSource() {
        
        let nameCellRegistration = UICollectionView.CellRegistration<NameCollectionViewCell, String> { cell, indexPath, itemIdentifier in
            cell.nameTextField.text = itemIdentifier
        }
        let amountCellRegistration = UICollectionView.CellRegistration<AmountCollectionViewCell, String>  { cell, indexPath, itemIdentifier in
            cell.amountLabel.text = itemIdentifier
        }
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.subtitleCell()
            content.text = itemIdentifier
            content.textProperties.alignment = .center
            cell.contentConfiguration = content
        }

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch Section.allCases[indexPath.section] {
            case .name:
                let cell = collectionView.dequeueConfiguredReusableCell(using: nameCellRegistration, for: indexPath, item: itemIdentifier)
                cell.passName = { value in
                    self.viewModel.inputName.value = value
                }
                return cell
            case .amount:
                let cell = collectionView.dequeueConfiguredReusableCell(using: amountCellRegistration, for: indexPath, item: itemIdentifier)
                cell.minusButtonAction = {
                    self.viewModel.inputMinusAmount.value = self.viewModel.outputAmount.value
                }
                cell.plusButtonAction = {
                    self.viewModel.inputPlusAmount.value = self.viewModel.outputAmount.value
                }
                return cell
            default:
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
                return cell
            }
        })
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([viewModel.outputName.value], toSection: .name)
        snapshot.appendItems([viewModel.outputAmountString.value], toSection: .amount)
        snapshot.appendItems([viewModel.outputStartDayString.value], toSection: .startDay)
        snapshot.appendItems([viewModel.outputCycleString.value], toSection: .cycle)
        snapshot.appendItems(viewModel.outputTimeListString.value, toSection: .time)
        dataSource.apply(snapshot)
        
    }
}

extension AddViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Section.allCases[indexPath.section] {
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

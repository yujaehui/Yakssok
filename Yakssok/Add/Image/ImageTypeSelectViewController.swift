//
//  ImageTypeSelectViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/15/24.
//

import UIKit
import SnapKit
import AVFoundation

enum ImageType: String, CaseIterable {
    case icon = "아이콘에서 선택"
    case image = "라이브러리에서 선택"
    case camera = "사진 찍기"
}

class ImageTypeSelectViewController: BaseSheetViewController {
    var selectImage: ((UIImage) -> Void)?
    let viewModel = ImageTypeSelectViewModel()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        setToolBar()
        bindData()
    }
    
    func bindData() {
        viewModel.selectImage.bind { [weak self] value in
            guard let value = value else { return }
            let vc = UIImagePickerController()
            vc.allowsEditing = true
            vc.delegate = self
            self?.present(vc, animated: true)
        }
        
        viewModel.selectCamera.bind { [weak self] value in
            guard let value = value else { return }
            AVCaptureDevice.requestAccess(for: .video) { [weak self] isAuthorized in
                guard isAuthorized else {
                    self?.showAlertGoToSetting()
                    return
                }
                
                DispatchQueue.main.async {
                    let vc = UIImagePickerController()
                    vc.sourceType = .camera
                    vc.allowsEditing = false
                    vc.delegate = self
                    self?.present(vc, animated: true)
                }
            }
        }
    }
    
    func showAlertGoToSetting() {
        let alertController = UIAlertController(title: "현재 카메라 사용에 대한 접근 권한이 없습니다.", message: "설정 > {앱 이름}탭에서 접근을 활성화 할 수 있습니다.", preferredStyle: .alert)
        let cancelAlert = UIAlertAction(title: "취소", style: .cancel) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        let goToSettingAlert = UIAlertAction(title: "설정으로 이동하기", style: .default) { _ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingURL) else { return }
            UIApplication.shared.open(settingURL, options: [:])
        }
        [cancelAlert, goToSettingAlert].forEach(alertController.addAction(_:))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ImageTypeSelectTableViewCell.self, forCellReuseIdentifier: ImageTypeSelectTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(rightBarButtonItemClikced))
    }
    
    @objc private func rightBarButtonItemClikced() {
        dismiss(animated: true)
    }
    
    private func setToolBar() {
        navigationController?.isToolbarHidden = false
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let registrationButton = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(registrationButtonClicked))
        let barItems = [flexibleSpace, registrationButton, flexibleSpace]
        self.toolbarItems = barItems
    }
    
    @objc private func registrationButtonClicked() {
        dismiss(animated: true)
    }
}

extension ImageTypeSelectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ImageType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageTypeSelectTableViewCell.identifier, for: indexPath) as! ImageTypeSelectTableViewCell
        let data = ImageType.allCases[indexPath.row]
        cell.configureCell(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch ImageType.allCases[indexPath.row] {
        case .icon: return
        case .image: viewModel.selectImage.value = ()
        case .camera: viewModel.selectCamera.value = ()
        }
    }
}

extension ImageTypeSelectViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            dismiss(animated: true)
            return
        }
        selectImage?(image)
        self.dismiss(animated: true)
        dismiss(animated: true)
    }
}

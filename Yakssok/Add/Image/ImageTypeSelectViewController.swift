//
//  ImageTypeSelectViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/15/24.
//

import UIKit
import SnapKit
import AVFoundation
import PhotosUI

enum MyImageVersion: String, CaseIterable {
    case image = "라이브러리에서 선택"
    case camera = "사진 찍기"
    case delete = "현재 사진 삭제"
    
    var image: UIImage {
        switch self {
        case .image: return UIImage(systemName: "photo") ?? UIImage()
        case .camera: return UIImage(systemName: "camera")  ?? UIImage()
        case .delete: return UIImage(systemName: "trash") ?? UIImage()
        }
    }
    
    var color: UIColor {
        switch self {
        case .delete: return ColorStyle.caution
        default: return ColorStyle.text
        }
    }
    
    var isHidden: Bool {
        return self == .delete
    }
}

final class ImageTypeSelectViewController: BaseViewController {
    var passImage: ((UIImage) -> Void)?
    
    let viewModel = ImageTypeSelectViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ImageTypeSelectTableViewCell.self, forCellReuseIdentifier: ImageTypeSelectTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        bindData()
    }
    
    private func bindData() {
        viewModel.selectImage.bind { [weak self] value in
            guard let _ = value else { return }
            
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .images
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self?.present(picker, animated: true)
        }
        
        viewModel.selectCamera.bind { [weak self] value in
            guard let _ = value else { return }
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
        
        viewModel.selectDelete.bind { [weak self] value in
            guard let _ = value else { return }
            self?.passImage?(ImageStyle.supplement)
            self?.dismiss(animated: true)
        }
    }
    
    private func showAlertGoToSetting() {
        let alertController = UIAlertController(title: "현재 카메라 사용에 대한 접근 권한이 없습니다.", message: "설정 > 약쏙 탭에서 접근을 활성화 할 수 있습니다.", preferredStyle: .alert)
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
    
    private func setNav() {
        navigationController?.navigationBar.tintColor = ColorStyle.point
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(rightBarButtonItemClikced))
    }

    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc private func rightBarButtonItemClikced() {
        dismiss(animated: true)
    }
}

extension ImageTypeSelectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyImageVersion.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageTypeSelectTableViewCell.identifier, for: indexPath) as! ImageTypeSelectTableViewCell
        let data = MyImageVersion.allCases[indexPath.row]
        cell.configureCell(data)
        if data.isHidden && viewModel.outputCurrentImage.value {
            cell.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch MyImageVersion.allCases[indexPath.row] {
        case .image: viewModel.selectImage.value = ()
        case .camera: viewModel.selectCamera.value = ()
        case .delete: viewModel.selectDelete.value = ()
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
        passImage?(image)
        self.dismiss(animated: true)
        dismiss(animated: true)
    }
}

extension ImageTypeSelectViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                self.passImage?((image as? UIImage)!)
            }
        }
        picker.dismiss(animated: true)
        dismiss(animated: true)
    }
}

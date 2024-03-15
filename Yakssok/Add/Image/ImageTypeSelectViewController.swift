//
//  ImageTypeSelectViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/15/24.
//

import UIKit

enum ImageType: String, CaseIterable {
    case icon = "아이콘에서 선택"
    case image = "라이브러리에서 선택"
    case camera = "사진 찍기"
}

class ImageTypeSelectViewController: BaseViewController {
    var selectImage: ((UIImage) -> Void)?
    let viewModel = ImageTypeSelectViewModel()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        setToolBar()
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
        cell.typeLabel.text = ImageType.allCases[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch ImageType.allCases[indexPath.row] {
        case .icon:
            print("icon")
        case .image:
            let vc = UIImagePickerController()
            vc.allowsEditing = true
            vc.delegate = self
            present(vc, animated: true)
        case .camera:
            print("camera")
        }
    }
}

extension ImageTypeSelectViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectImage?(pickedImage)
        }
        self.dismiss(animated: true)
        dismiss(animated: true)
    }
}

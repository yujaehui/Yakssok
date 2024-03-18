//
//  ImageTypeSelectViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/15/24.
//

import Foundation

class ImageTypeSelectViewModel {
    
    let selectImage: Observable<Void?> = Observable(nil)
    let selectCamera: Observable<Void?> = Observable(nil)
    let selectDelete: Observable<Void?> = Observable(nil)
    
    var inputCurrentImage: Observable<Bool?> = Observable(nil)
    var outputCurrentImage: Observable<Bool> = Observable(true)
    
    init() {
        inputCurrentImage.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputCurrentImage.value = value
        }
    }
}

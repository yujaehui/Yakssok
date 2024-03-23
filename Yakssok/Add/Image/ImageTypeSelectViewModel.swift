//
//  ImageTypeSelectViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/15/24.
//

import Foundation

final class ImageTypeSelectViewModel {
    
    // input
    var inputCurrentImage: Observable<Bool?> = Observable(nil)
    
    // output
    var outputCurrentImage: Observable<Bool> = Observable(true)
    
    // transition
    let selectImage: Observable<Void?> = Observable(nil)
    let selectCamera: Observable<Void?> = Observable(nil)
    let selectDelete: Observable<Void?> = Observable(nil)
    
    init() {
        inputCurrentImage.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputCurrentImage.value = value
        }
    }
}

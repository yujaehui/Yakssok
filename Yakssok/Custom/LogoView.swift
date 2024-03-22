//
//  LogoView.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/22/24.
//

import UIKit

final class LogoView: UIView {
    let imageView =  UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 5, width: 70, height: 35)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        addSubview(imageView)
        imageView.image = ImageStyle.logo
        imageView.contentMode = .scaleAspectFit
        imageView.frame = self.bounds
    }
}

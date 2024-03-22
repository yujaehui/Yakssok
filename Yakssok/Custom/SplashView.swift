//
//  SplashView.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/22/24.
//

import UIKit
import SnapKit
import Lottie

final class SplashView: BaseView {
    
    private let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()
    
    private let animationView: LottieAnimationView = {
        let lottieAnimationView = LottieAnimationView(name: "splash")
        lottieAnimationView.animationSpeed = 2.5
        lottieAnimationView.contentMode = .scaleAspectFit
        lottieAnimationView.alpha = 1
        return lottieAnimationView
    }()
    
    private let logoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = ImageStyle.logo
        return imageView
    }()
    
    var animationCompletionHandler: (() -> Void)?
    
    override func configureHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubview(animationView)
        stackView.addArrangedSubview(logoImageView)
    }
    
    override func configureView() {
        animationView.play { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.animationView.alpha = 0
                self.logoImageView.alpha = 0
            }, completion: { _ in
                self.animationView.isHidden = true
                self.animationView.removeFromSuperview()
                self.logoImageView.isHidden = true
                self.logoImageView.removeFromSuperview()
                self.animationCompletionHandler?()
            })
        }
    }
    
    override func configureConstraints() {
        stackView.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
        }
        
        animationView.snp.makeConstraints { make in
            make.size.equalTo(150)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
}

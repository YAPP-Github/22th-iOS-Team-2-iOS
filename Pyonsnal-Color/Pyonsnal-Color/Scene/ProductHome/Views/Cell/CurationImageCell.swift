//
//  CurationImageCell.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/24.
//

import UIKit
import SnapKit
import Lottie

final class CurationImageCell: UICollectionViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let introductionImageView: LottieAnimationView = {
        let animation = LottieAnimation.named("main")
        let animationView = LottieAnimationView(animation: animation)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
        return animationView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        addSubview(containerView)
        containerView.addSubview(introductionImageView)

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        introductionImageView.frame = self.bounds
    }
}

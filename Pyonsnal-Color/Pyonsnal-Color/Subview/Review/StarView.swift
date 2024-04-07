//
//  StarView.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/10/03.
//

import UIKit

final class StarView: UIButton {
    enum ViewMode: String {
        case large, medium
    }
    
    enum Image {
        static let star: String = "star"
        static let starFilled: String = "star_filled"
    }
    
    let index: Int
    private let mode: ViewMode
    private let maxScore: Double = 1.0
    private var starImage: UIImage? {
        return UIImage(named: "\(Image.star)_\(mode.rawValue)")
    }
    private var starFilledImage: UIImage? {
        return UIImage(named: "\(Image.starFilled)_\(mode.rawValue)")
    }
    
    init(index: Int, mode: ViewMode) {
        self.index = index
        self.mode = mode
        super.init(frame: .zero)

        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        setImage(starImage, for: .normal)
    }
    
    func fillDecimalStar(to score: Double) {
        guard let imageSize = starFilledImage?.size,
              0 < score, score <= maxScore
        else {
            return
        }
        
        let cropSize = CGRect(
            x: 0,
            y: 0,
            width: imageSize.width * score,
            height: imageSize.height
        )
        let imageView = UIImageView(frame: cropSize)
        imageView.image = starFilledImage
        imageView.clipsToBounds = true
        imageView.contentMode = .left
        
        addSubview(imageView)
    }
    
    func setFilledStarImage() {
        setImage(starFilledImage, for: .normal)
    }
    
    func setStarImage() {
        setImage(starImage, for: .normal)
    }
}

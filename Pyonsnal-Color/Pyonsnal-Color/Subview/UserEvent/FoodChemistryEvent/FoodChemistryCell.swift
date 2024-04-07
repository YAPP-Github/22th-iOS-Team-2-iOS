//
//  FoodChemistryCell.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 1/23/24.
//

import UIKit

final class FoodChemistryCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .clear
    }
}

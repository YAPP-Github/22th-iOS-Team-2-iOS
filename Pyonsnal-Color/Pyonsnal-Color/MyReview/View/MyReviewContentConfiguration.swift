//
//  MyReviewContentConfiguration.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 5/19/24.
//

import UIKit

struct MyReviewContentConfiguration: UIContentConfiguration {
    var storeImageIcon: ConvenienceStore
    var imageUrl: URL
    var title: String
    var date: String?
    var mode: ProductInfoStackView.Mode
    var tastesTag: [String]?
    
    init(
        mode: ProductInfoStackView.Mode,
        storeImageIcon: ConvenienceStore,
        imageUrl: URL,
        title: String,
        date: String? = nil,
        tastesTag: [String]? = nil
    ) {
        self.mode = mode
        self.storeImageIcon = storeImageIcon
        self.imageUrl = imageUrl
        self.title = title
        self.date = date
        self.tastesTag = tastesTag
    }
    
    func makeContentView() -> any UIView & UIContentView {
        return MyReviewContentView(configuration: self, mode: mode)
    }
    
    func updated(for state: any UIConfigurationState) -> MyReviewContentConfiguration {
        return self
    }
}

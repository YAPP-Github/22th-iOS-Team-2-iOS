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
    
    init(storeImageIcon: ConvenienceStore, imageUrl: URL, title: String, date: String? = nil) {
        self.storeImageIcon = storeImageIcon
        self.imageUrl = imageUrl
        self.title = title
        self.date = date
    }
    
    func makeContentView() -> any UIView & UIContentView {
        return MyReviewContentView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> MyReviewContentConfiguration {
        return self
    }
}

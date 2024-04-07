//
//  ItemIdentifier.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/28.
//

import Foundation

protocol ItemIdentifier {
    static var identifier: String { get }
}

extension ItemIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}

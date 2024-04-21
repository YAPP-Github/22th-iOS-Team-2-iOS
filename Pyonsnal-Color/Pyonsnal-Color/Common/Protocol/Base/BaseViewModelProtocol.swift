//
//  BaseViewModelProtocol.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 4/21/24.
//

import Foundation

protocol BaseViewModelProtocol {
    associatedtype Action
    associatedtype Output
    associatedtype Dependency
    associatedtype Payload
    
    func bindActions()
}

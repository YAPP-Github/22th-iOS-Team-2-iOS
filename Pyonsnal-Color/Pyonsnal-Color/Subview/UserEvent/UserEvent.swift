//
//  UserEvent.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 1/23/24.
//

import UIKit

enum UserEvent: String, Decodable {
    case launchingEvent
    case foodChemistryEvent
}

struct UserEventDetail {
    let title: String
    let urlString: String
}

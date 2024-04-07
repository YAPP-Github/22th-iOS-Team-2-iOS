//
//  ControlPublisher.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/06.
//

import UIKit
import Combine

struct ControlPublisher: Publisher {
    typealias Output = UIControl
    typealias Failure = Never
    
    private let control: UIControl
    private let controlEvent: UIControl.Event
    
    init(control: UIControl, controlEvent: UIControl.Event) {
        self.control = control
        self.controlEvent = controlEvent
    }
    
    func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, UIControl == S.Input {
        let subscription = ControlSubscription(
            subscriber: subscriber,
            control: control,
            controlEvent: controlEvent
        )
        subscriber.receive(subscription: subscription)
    }
}

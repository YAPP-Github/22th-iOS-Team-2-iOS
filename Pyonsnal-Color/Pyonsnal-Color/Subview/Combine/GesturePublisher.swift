//
//  GesturePublisher.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/06.
//

import UIKit
import Combine

struct GesturePublisher: Publisher {
    
    typealias Output = UIGestureRecognizer
    typealias Failure = Never
    
    private weak var targetView: UIView?
    private let gestureRecognizer: UIGestureRecognizer
    
    init(targetView: UIView, gestureRecognizer: UIGestureRecognizer) {
        self.targetView = targetView
        self.gestureRecognizer = gestureRecognizer
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, UIGestureRecognizer == S.Input {
        let subscription = GestureSubscription(subscriber: subscriber, view: targetView, gestureRecognizer: gestureRecognizer)
        subscriber.receive(subscription: subscription)
    }
}

//
//  GestureSubscription.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/06.
//

import UIKit
import Combine

final class GestureSubscription<GestureSubscriber: Subscriber>: Subscription where GestureSubscriber.Input == GesturePublisher.Output, GestureSubscriber.Failure == GesturePublisher.Failure {
    private let selector = #selector(gestureHandler)
    private var subscriber: GestureSubscriber?
    private weak var targetView: UIView?
    private let gestureRecognizer: UIGestureRecognizer
    
    init(subscriber: GestureSubscriber?, view: UIView?, gestureRecognizer: UIGestureRecognizer) {
        self.subscriber = subscriber
        self.targetView = view
        self.gestureRecognizer = gestureRecognizer
        
        self.targetView?.isUserInteractionEnabled = true
        gestureRecognizer.addTarget(self, action: selector)
        self.targetView?.addGestureRecognizer(gestureRecognizer)
    }
    
    func request(_ demand: Subscribers.Demand) { } // 구현 필요 없음
    
    func cancel() {
        subscriber = nil
        targetView?.isUserInteractionEnabled = false
        gestureRecognizer.removeTarget(self, action: selector)
    }
    
    @objc
    private func gestureHandler() {
        _ = subscriber?.receive(gestureRecognizer)
    }
}

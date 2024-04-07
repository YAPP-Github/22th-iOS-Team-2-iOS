//
//  ControlSubscription.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/06.
//

import UIKit
import Combine

final class ControlSubscription<ControlSubscriber: Subscriber>: Subscription where ControlSubscriber.Input == ControlPublisher.Output, ControlSubscriber.Failure == ControlPublisher.Failure {
    private let selector = #selector(eventHandler)
    private var subscriber: ControlSubscriber?
    private let control: UIControl
    private let controlEvent: UIControl.Event
    
    init(subscriber: ControlSubscriber, control: UIControl, controlEvent: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        self.controlEvent = controlEvent
        control.addTarget(self, action: selector, for: controlEvent)
    }
    
    func request(_ demand: Subscribers.Demand) { } // 구현 필요 없음
    
    func cancel() {
        subscriber = nil
        control.removeTarget(self, action: selector, for: controlEvent)
    }
    
    @objc
    func eventHandler() {
        _ = subscriber?.receive(control)
    }
}
       

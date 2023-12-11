//
//  RepeatingTaskmaster.swift
//
//
//  Created by מאיר רדנוביץ׳ on 20/11/2023.
//  Based on https://medium.com/over-engineering/a-background-repeating-timer-in-swift-412cecfd2ef9

import Foundation

actor RepeatingTaskmaster {
    let timeInterval: TimeInterval
    private(set) var eventHandler: (() async -> Void)?
    private let queue = DispatchQueue(label: "xyz.spindl.queue.background", qos: .utility, attributes: [.concurrent], autoreleaseFrequency: .workItem, target: nil)
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource(queue: queue)
        t.schedule(deadline: .now() + timeInterval, repeating: timeInterval)
        t.setEventHandler(handler: { [weak self] in
            Task { [weak self] in
                await self?.eventHandler?()
            }
        })
        return t
    }()
    
    private enum State {
        case suspended
        case resumed
    }
    
    private var state = State.suspended
    
    init(timeInterval: TimeInterval, callback: (() async -> Void)? = nil) {
        self.timeInterval = timeInterval
        self.eventHandler = callback
    }
    
    deinit {
        Task {
            await timer.setEventHandler(handler: {})
            await timer.cancel()
            await resume()
        }
        
        eventHandler = nil
    }
    
    func setEventHandler(_ handler: @escaping () async -> Void) {
        eventHandler = handler
    }
    
    func resume() {
            if state == .resumed {
                return
            }
            state = .resumed
            timer.resume()
        }
    
    func suspend() {
            if state == .suspended {
                return
            }
            state = .suspended
            timer.suspend()
        }
}

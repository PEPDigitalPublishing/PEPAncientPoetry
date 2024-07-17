//
//  PRPoetryCountdownTimer.swift
//  PEPRead
//
//  Created by sunShine on 2024/3/27.
//  Copyright © 2024 PEP. All rights reserved.
//

import Foundation
class PRPoetryCountdownTimer {
    var countdown: Int //注意单位是毫米
    var timer: DispatchSourceTimer?
    var callback: ((Int) -> Void)?
    var stopCallback: ( () -> Void)?
    var startTime = 0
    var customTimeInterval: DispatchTimeInterval = .milliseconds(10)
    
    init(countdown: Int) {
        self.countdown = countdown
    }
    
    func start() {
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        //倒计时的时间间隔也设置成10ms
        timer?.schedule(deadline: .now(), repeating: customTimeInterval)
        timer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            if self.countdown > 0 {
                self.callback?(self.countdown)
                self.countdown -= 10
            } else {
                self.stop()
            }
        }
        timer?.resume()
    }
    func startWithSeconds() {
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        //倒计时的时间间隔也设置成1000ms
        timer?.schedule(deadline: .now(), repeating: customTimeInterval)
        timer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            if self.countdown > 0 {
                self.callback?(self.countdown)
                self.countdown -= 1000
            } else {
                self.stop()
            }
        }
        timer?.resume()
    }
    func startWithAccumulation() {
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        //倒计时的时间间隔也设置成10ms
        timer?.schedule(deadline: .now(), repeating: .milliseconds(10))
        timer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            self.startTime += 10
            if self.startTime <= self.countdown {
                self.callback?(self.startTime)
                
            } else {
                self.stop()
            }
        }
        timer?.resume()
    }
    
    func stop() {
        timer?.cancel()
        timer = nil
        stopCallback?()
        print("Countdown stopped.")
    }
}

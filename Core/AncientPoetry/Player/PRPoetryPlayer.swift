//
//  PRPoetryPlayer.swift
//  PEPRead
//
//  Created by sunShine on 2024/1/29.
//  Copyright © 2024 PEP. All rights reserved.
//

import UIKit
import AVFoundation
enum PRPoetryPlayerStatus{
    case playCompletion, playInterrupt
}


protocol PRPoetryPlayerDelegate: AnyObject {
    func audioPlayer(_ audioPlayer: PRPoetryPlayer, didUpdateProgress progress: Float, _ currentTime: Int)
    func audioPlayer(_ audioPlayer: PRPoetryPlayer, didFailWithError error: Error?)
    func audioPlayerTimeControlStatusChanged(_ audioPlayer: AVPlayer, status: AVPlayer.TimeControlStatus)


}

class PRPoetryPlayer: NSObject {
    var player: AVPlayer?
    var onlyPlayItem: AVPlayerItem?
    var audioSession: AVAudioSession?
    var timeObserver: Any?
    weak var delegate: PRPoetryPlayerDelegate?
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    deinit {
        removeObservers()
        removeTimeObserver()
    }
    
    private func setupAudioSession() {
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession?.setCategory(.playback)
            try audioSession?.setActive(true)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
    }
    
    func play(url: URL) {
        player = AVPlayer(url: url)
        player?.volume = 1.5
        player?.play()
        addTimeObserver()
        addObservers()
        
    }
    func playOnly(url: URL){
        onlyPlayItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: onlyPlayItem)
        player?.volume = 1.5
        player?.play()
        addTimeObserver()
        addObservers()
        
    }
    
    func pause() {
        player?.pause()
    }
    func resume() {
        if isPaused() {
            player?.play()
        }
        }
    func stop() {
        player?.pause()
        player?.seek(to: CMTime.zero)
    }
    
    func seek(to time: TimeInterval) {
        let jumpTimeInSeconds = time / 1000
        player?.seek(to: CMTime(seconds: jumpTimeInSeconds, preferredTimescale: 44100))
        
    }
    
    func preloadAudio(from url: URL) {
            let asset = AVAsset(url: url)
            let keys = ["playable"]
            
            asset.loadValuesAsynchronously(forKeys: keys) { [weak self] in
                guard let self = self else { return }
                var error: NSError? = nil
                let status = asset.statusOfValue(forKey: "playable", error: &error)
                switch status {
                case .loaded:
                    DispatchQueue.main.async {
                        self.player = AVPlayer(url: url)
                        self.player?.volume = 1.5
                        self.addTimeObserver()
                        self.addObservers()
                        print("Audio preloaded successfully")
                    }
                case .failed, .cancelled:
                    print("Failed to preload audio: \(String(describing: error))")
                default:
                    // This case should never be executed
                    break
                }
            }
        }
    
    private func addObservers() {
            guard let player = player else { return }
            
            // 监听 AVPlayer 的 timeControlStatus 属性
            player.addObserver(self, forKeyPath: "timeControlStatus", options: [.new, .old], context: nil)
    }
    private func removeObservers() {
            guard let player = player else { return }
            
            // 移除 AVPlayer 的 timeControlStatus 属性监听
            player.removeObserver(self, forKeyPath: "timeControlStatus")
    }
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] time in
        guard let duration = self?.player?.currentItem?.duration.seconds, duration > 0 else { return }
        let seconds = CMTimeGetSeconds(time)
        let progress = Float(seconds / duration)
        self?.delegate?.audioPlayer(self!, didUpdateProgress: progress, Int(seconds * 1000))
            
        })
    }
    
    
    private func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "timeControlStatus" {
                if let playerT = player {
                    delegate?.audioPlayerTimeControlStatusChanged(playerT, status: playerT.timeControlStatus)
                }
            }
        }
    
    func isPaused() -> Bool {
            return player?.timeControlStatus == .paused
        }
    
    func isPlaying() -> Bool {
            return player?.timeControlStatus == .playing
        }
}

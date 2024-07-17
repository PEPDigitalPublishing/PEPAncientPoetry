//
//  PRPCMPlayer.swift
//  PEPRead
//
//  Created by sunShine on 2023/5/16.
//  Copyright © 2023 PEP. All rights reserved.
//

import Foundation
import AVFoundation

class PCMPlayer {
    let engine = AVAudioEngine()
    let player = AVAudioPlayerNode()
    var buffer: AVAudioPCMBuffer?

    init() {
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 44100, channels: 1, interleaved: false)
        let input = engine.inputNode

        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: format)

        let capacity = AVAudioFrameCount(44100 * 2) // 2 seconds of buffer
        buffer = AVAudioPCMBuffer(pcmFormat: format!, frameCapacity: capacity)!
    }

    func play(pcmData: Data) {
        guard let buffer = buffer else { return }
        buffer.frameLength = buffer.frameCapacity

        // Copy the PCM data to the buffer
        let channelData = buffer.floatChannelData![0]
        pcmData.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            let audioBuffer = bytes.bindMemory(to: Float.self)
            for i in 0..<Int(buffer.frameLength) {
                channelData[i] = audioBuffer[i]
            }
        }

        // Play the buffer
        player.scheduleBuffer(buffer, completionHandler: nil)
        engine.prepare()
        try? engine.start()
        player.play()
    }
}

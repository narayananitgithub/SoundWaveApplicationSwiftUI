//
//  AudioManager.swift
//  SoundWaveApplicationSwiftUI
//
//  Created by Narayanasamy on 20/12/24.
//

import AVFoundation
import Combine
import SwiftUI

class AudioManager: ObservableObject {
    // MARK: - Properties
    @Published var frequencies: [Float] = Array(repeating: 0, count: 30)
    @Published var isPlaying: Bool = false
    @Published var audioPlayer: AVPlayer?
    private var playerStatusCancellable: AnyCancellable?

    private var audioEngine: AVAudioEngine!
// MARK: - initializer
    init() {
        setupAudioSession()
        setupAudioEngine()
        setupAudioPlayer()
    }
// MARK: - setupAudioSession
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.allowBluetooth, .defaultToSpeaker])
            try audioSession.setActive(true)
        } catch {
            print("Audio session setup failed: \(error.localizedDescription)")
        }
    }
// MARK: - setupAudioEngine
    private func setupAudioEngine() {
        if audioEngine == nil {
            audioEngine = AVAudioEngine()
        }
        if audioEngine.isRunning { return }
        let inputNode = audioEngine.inputNode
        let bus = 0
        let inputFormat = inputNode.inputFormat(forBus: bus)
        print("Input Format: Sample Rate - \(inputFormat.sampleRate), Channels - \(inputFormat.channelCount)")
        if inputFormat.sampleRate == 0 || inputFormat.channelCount == 0 {
            print("Invalid input format.")
            return
        }
        let bufferSize: AVAudioFrameCount = 512
        inputNode.installTap(onBus: bus, bufferSize: bufferSize, format: inputFormat) { [weak self, weak inputNode, weak audioEngine] buffer, _ in
            guard let self = self, let inputNode = inputNode, let audioEngine = audioEngine else { return }
            if let floatChannelData = buffer.floatChannelData?.pointee {
                let audioData = Array(UnsafeBufferPointer(start: floatChannelData, count: Int(buffer.frameLength)))
                let fft = FFT(log2n: Int(log2(Double(audioData.count))))
                let fftData = fft.realForward(audioData)
                let frequencyMagnitudes = fftData.map { abs($0) }
                DispatchQueue.main.async {
                    self.frequencies = Array(frequencyMagnitudes.prefix(self.frequencies.count))
                }
            }
        }

        do {
            try audioEngine.start()
        } catch {
            print("Audio Engine Error: \(error.localizedDescription)")
        }
    }
// MARK: - setupAudioPlayer
    private func setupAudioPlayer() {
        guard let audioFilePath = Bundle.main.path(forResource: "SoundWave", ofType: "mp3") else {
            print("Audio file not found at the expected path.")
            return
        }
        let audioURL = URL(fileURLWithPath: audioFilePath)
        let playerItem = AVPlayerItem(url: audioURL)
        audioPlayer = AVPlayer(playerItem: playerItem)
        playerStatusCancellable = audioPlayer?.publisher(for: \.status)
            .sink { [weak self] status in
                guard let self = self else { return }
                switch status {
                case .readyToPlay:
                    print("Player ready to play")
                case .failed:
                    print("Player failed: \(playerItem.error?.localizedDescription ?? "Unknown error")")
                case .unknown:
                    print("Player status unknown")
                @unknown default:
                    print("Unknown player status")
                }
            }
    }
// MARK: - playPause
    func playPause() {
        if isPlaying {
            print("Pausing audio")
            audioPlayer?.pause()
        } else {
            print("Playing audio")
            audioPlayer?.play()
        }
        isPlaying.toggle()
    }
// MARK: - setVolume
    func setVolume(_ volume: Double) {
        audioPlayer?.volume = Float(volume)
    }
// MARK: -  skipBackward
    func skipBackward() {
        guard let currentTime = audioPlayer?.currentTime() else { return }
        let newTime = currentTime - CMTime(seconds: 10, preferredTimescale: currentTime.timescale)
        audioPlayer?.seek(to: newTime)
    }
// MARK: - skipForward
    func skipForward() {
        guard let currentTime = audioPlayer?.currentTime() else { return }
        let newTime = currentTime + CMTime(seconds: 10, preferredTimescale: currentTime.timescale)
        audioPlayer?.seek(to: newTime)
    }
// MARK: - deinit
    deinit {
        if let engine = audioEngine, engine.isRunning {
            engine.stop()
            engine.inputNode.removeTap(onBus: 0)
        }
        playerStatusCancellable?.cancel()
        print("AudioManager deinitialized")
    }
}
// **Implement the FFT class (example using Accelerate framework)**
class FFT {
    let log2n: Int

    init(log2n: Int) {
        self.log2n = log2n
    }

    func realForward(_ input: [Float]) -> [Float] {
        return input
    }
}

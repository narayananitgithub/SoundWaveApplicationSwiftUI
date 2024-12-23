//
//  ContentView.swift
//  SoundWaveApplicationSwiftUI
//
//  Created by Narayanasamy on 20/12/24.
//

import SwiftUI

struct ParentView: View {
    // MARK: - Properties
    @StateObject private var audioManager = AudioManager()
    @State private var animateButton = false
    @State private var volume: Double = 0.5
    @State private var isMuted: Bool = false
    @State private var animateCircle = false
    @State private var circlePosition: CGPoint = .zero
    @State private var visualizationCenter: CGPoint = .zero
    @State private var animateRingMovement = false

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                topControls
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)

                Spacer()
                VStack {
                    GeometryReader { geometry in
                        RotatingRingsView(audioManager: audioManager, animateButton: $animateButton)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .padding(.horizontal)
                            .background(
                                GeometryReader { proxy in
                                    Color.clear
                                        .onAppear {
                                            visualizationCenter = CGPoint(
                                                x: proxy.frame(in: .global).midX,
                                                y: proxy.frame(in: .global).midY
                                            )
                                        }
                                }
                            )
                            .offset(y: animateRingMovement ? -50 : 0)
                            .animation(.easeInOut(duration: 1), value: animateRingMovement)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                Spacer()
                playbackControls
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Circle()
                .fill(Color.white)
                .frame(width: 20, height: 20)
                .position(circlePosition)
                .opacity(animateCircle ? 0 : 0)
        }
    }
// MARK: - topControls
    private var topControls: some View {
        HStack(spacing: 20) {
            muteButton
            Slider(value: $volume, in: 0...1)
                .frame(width: 200)
                .onChange(of: volume) { newValue in
                    isMuted = newValue == 0
                    audioManager.setVolume(newValue)
                }

        }
    }
// MARK: - playbackControls
    private var playbackControls: some View {
        HStack {
            skipBackwardButton
            Spacer()
            playPauseButton
                .frame(width: 80, height: 80)
                .padding()
            Spacer()
            skipForwardButton
        }
        .padding(.horizontal, 40)
    }
    // MARK: - playPauseButton
    private var playPauseButton: some View {
        Button(action: {
            animateCircleMotion()
            audioManager.playPause()
            animateButton.toggle()
        }) {
            Image(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
        }
    }
// MARK: - animateCircleMotion
    private func animateCircleMotion() {
        withAnimation(.easeInOut(duration: 1)) {
            animateCircle = true
            circlePosition = CGPoint(
                x: UIScreen.main.bounds.width / 2,
                y: UIScreen.main.bounds.height - 150
            )
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeInOut(duration: 1)) {
                circlePosition = visualizationCenter
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            animateCircle = false
        }
    }
// MARK: - muteButton
    private var muteButton: some View {
        Button(action: {
            isMuted.toggle()
            volume = isMuted ? 0 : 0.5
            audioManager.setVolume(volume)
        }) {
            Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
        }
    }
// MARK: - skipBackwardButton
    private var skipBackwardButton: some View {
        Button(action: {
            audioManager.skipBackward()
        }) {
            Image(systemName: "gobackward.10")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
        }
    }
// MARK: - skipForwardButton
    private var skipForwardButton: some View {
        Button(action: {
            audioManager.skipForward()
        }) {
            Image(systemName: "goforward.10")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
        }
    }
}
// MARK: - ParentView_Previews
struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView()
            .previewDevice("iPhone 14")
            .preferredColorScheme(.dark)
    }
}

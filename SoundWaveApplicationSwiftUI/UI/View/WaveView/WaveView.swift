//
//  WaveView.swift
//  SoundWaveApplicationSwiftUI
//
//  Created by Narayanasamy on 20/12/24.
//

import SwiftUI


struct RotatingRingsView: View {
    // MARK: - Properties
    @ObservedObject var audioManager: AudioManager
    @Binding var animateButton: Bool
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Spacer()
                    HStack {
                        ForEach(0..<10, id: \.self) { index in
                            Rectangle()
                                .frame(width: 4, height: animateButton ? CGFloat.random(in: 10...geometry.size.height * 0.6) : 20)
                                .foregroundColor(index.isMultiple(of: 2) ? .blue : .cyan)
                                .animation(.easeInOut(duration: 0.1).repeatForever(autoreverses: true), value: animateButton)
                        }
                    }
                    .frame(width: geometry.size.width, alignment: .center)
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}
// MARK: - RotatingRingsView_Previews
struct RotatingRingsView_Previews: PreviewProvider {
    static var previews: some View {
        RotatingRingsView(audioManager: AudioManager(), animateButton: .constant(true))
            .frame(width: 300, height: 300)
            .previewLayout(.sizeThatFits)
            .background(Color.black)
            .cornerRadius(20)
    }
}

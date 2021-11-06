//
//  SoundWaveView.swift
//  teumsae
//
//  Created by woogie on 2021/11/06.
//


import SwiftUI



struct SoundWaveView: View {
	
	@EnvironmentObject var customAudioRecorder: AudioRecorder
	@EnvironmentObject private var mic: MicrophoneMonitor
	

	
	private func normalizeSoundLevel(level: Float) -> CGFloat {
		let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
		
		return CGFloat(level * (300 / 25)) // scaled to max at 300 (our height of our bar)
	}
	
	var body: some View {
		VStack {
			HStack(spacing: 4) {
				ForEach(mic.soundSamples, id: \.self) { level in
					BarView(value: self.normalizeSoundLevel(level: level))
				}
			}
		}
	}
}

struct SoundWaveView_Previews: PreviewProvider {
	static var previews: some View {
		SoundWaveView().environmentObject(AudioRecorder())
	}
}

struct BarView: View {
	var value: CGFloat

	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 20)
				.fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
									 startPoint: .top,
									 endPoint: .bottom))
				.frame(width: (UIScreen.main.bounds.width - CGFloat(Const.numberOfSamples) * 4) / CGFloat(Const.numberOfSamples), height: value)
		}
	}
}

//
//  MicrophoneMonitor.swift
//  teumsae
//
//  Created by woogie on 2021/11/06.
//


import Foundation
import AVFoundation
import SwiftUI

class MicrophoneMonitor: ObservableObject {
	
	// properties
	@ObservedObject var customAudioRecorder: AudioRecorder = AudioRecorder.shared
	// 1
	private var audioRecorder: AVAudioRecorder {
		return customAudioRecorder.audioRecorder
	}
	
	private var timer: Timer?
	
	private var currentSample: Int
	private let numberOfSamples: Int
	
	// 2
	@Published public var soundSamples: [Float]
	
	// constructor
	init() {
		
		self.numberOfSamples = Const.numberOfSamples // In production check this is > 0.
		self.soundSamples = [Float](repeating: .zero, count: numberOfSamples)
		self.currentSample = 0
		
		// 3
//		let audioSession = AVAudioSession.sharedInstance()
//		if audioSession.recordPermission != .granted {
//			audioSession.requestRecordPermission { (isGranted) in
//				if !isGranted {
//					fatalError("You must allow audio recording for this demo to work")
//				}
//			}
//		}
	}
	
	// 6
	func startMonitoring() {
		audioRecorder.isMeteringEnabled = true
//		audioRecorder.record()
		timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
			// 7
			self.audioRecorder.updateMeters()
			self.soundSamples[self.currentSample] = self.audioRecorder.averagePower(forChannel: 0)
			self.currentSample = (self.currentSample + 1) % self.numberOfSamples
		})
	}
	func stopMonitoring() {
		audioRecorder.isMeteringEnabled = false
		timer?.invalidate()
	}
	// 8
	deinit {
		timer?.invalidate()
	}
}

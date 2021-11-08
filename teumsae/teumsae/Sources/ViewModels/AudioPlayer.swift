//
//  AudioPlayer.swift
//  teumsae
//
//  Created by seungyeon on 2021/11/05.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    
    var isPlaying = false {
            didSet {
                objectWillChange.send(self)
            }
        }
    
    var audioPlayer: AVAudioPlayer!
    
    func startPlayback (audio: URL){
        let playbackSession = AVAudioSession.sharedInstance()
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            } catch {
                print("Playing over the device's speakers failed")
        }
        do {
			print(audio)
			audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
        } catch  {
			print(error)
            print("Playback failed.")
        }
    }
    
    func stopPlayback(){
        audioPlayer.stop()
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("Finish"), object: nil)
        print("finish")
    }
    
}

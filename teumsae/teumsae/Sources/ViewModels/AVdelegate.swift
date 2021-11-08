//
//  AVdelegate.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/08.
//

import Foundation
import AVKit

class AVdelegate : NSObject,AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("Finish"), object: nil)
    }
}

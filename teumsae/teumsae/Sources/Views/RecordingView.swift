//
//  RecordingView.swift
//  teumsae
//
//  Created by 오수민 on 2021/11/06.
//

import Foundation
import SwiftUI

struct RecordingView: View {
    let recording: Recording
    @ObservedObject var audioPlayer = AudioPlayer()
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Divider()
                    .padding(.bottom)
                Text("Date")
                    .font(.headline)
                Text(recording.createdAt.toString(dateFormat: "YY/MM/dd"))
                if audioPlayer.isPlaying == false { // IF1 : NOT PLAYING
                    Button(action: {
                        // navigation
                        self.audioPlayer.startPlayback(audio: self.recording.fileURL)
                    }) {
                        Image(systemName: "play.circle")
                            .imageScale(.large)
                    }
                }
                else { // IF1-ELSE : CURRENTLY PLAYING
                    Button(action: {
                        self.audioPlayer.stopPlayback()
                    }) {
                        Image(systemName: "stop.fill")
                            .imageScale(.large)
                    }
                } // END OF IF1 CLAUSE
                
//                if let transcript = recording.transcript {
//                    Text("Transcript")
//                        .font(.headline)
//                        .padding(.top)
//                    Text(transcript)
//                }
            }
        }
    }
}


//struct RecordingView_Previews: PreviewProvider {
//    static var previews: some View {
//        let dateString = "2019-05-19"
//        RecordingView(recording:Recording(
//            fileURL: URL(string: "recordings/2"),
//            createdAt: dateString.toDate(),
//            transcript: "Darla, would you like to start today? Sure, yesterday I reviewed Luis' PR and met with the design team to finalize the UI..."))
//       }
//}

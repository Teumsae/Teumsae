//
//  RecordingsList.swift
//  teumsae
//
//  Created by seungyeon on 2021/11/04.
//

import SwiftUI
import Alamofire

struct RecordingsList: View {
    
	@ObservedObject var audioRecorder: AudioRecorder = AudioRecorder.shared
    
    var body: some View {
        List {
            ForEach(audioRecorder.recordings, id: \.createdAt) {
                recording in
                NavigationLink(destination: RecordingView(recording: recording),
                               label: {
                    RecordingRow(audioURL: recording.fileURL)
                })
            }
            .onDelete(perform: delete)
        }
    }

    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        for index in offsets{
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}

struct RecordingRow: View{
    
    var audioURL: URL
    
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var body: some View {

        HStack{
            Text("\(audioURL.lastPathComponent)")
            Spacer()
            if audioPlayer.isPlaying == false { // IF1 : NOT PLAYING
                Button(action: {
                    // navigation
                    self.audioPlayer.startPlayback(audio: self.audioURL)
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
        }
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList()
    }
}

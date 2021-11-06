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
    @State private var progress:Double = 0.8 * 100.0
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Subject")
                    .foregroundColor(.gray)
            }
            HStack{ //HSTACK2
                Text("\(audioURL.lastPathComponent)")
                Spacer()
                /*
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
                } // END OF IF1 CLAUSE*/
                Text("08:01")
            } // END OF HSTACK2
            HStack{ //HSTACK3
                Text("Tags")
                    .foregroundColor(.gray)
            } // END OF HSTACK3
            ProgressView(value: progress, total: 100.0)
        } // END OF VSTACK
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList()
    }
}

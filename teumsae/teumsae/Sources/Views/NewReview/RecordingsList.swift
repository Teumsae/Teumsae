//
//  RecordingsList.swift
//  teumsae
//
//  Created by seungyeon on 2021/11/04.
//

import SwiftUI

struct RecordingsList: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        List{
            ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                            RecordingRow(audioURL: recording.fileURL)
                        }
        }
    }
}

struct RecordingRow: View{
    
    var audioURL: URL
    var body: some View{
        HStack{
            Text("\(audioURL.lastPathComponent)")
            Spacer()
        }
        
    }
    
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(audioRecorder: AudioRecorder())
    }
}

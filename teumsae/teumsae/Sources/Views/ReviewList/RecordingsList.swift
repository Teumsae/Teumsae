//
//  RecordingsList.swift
//  teumsae
//
//  Created by seungyeon on 2021/11/04.
//

import SwiftUI
import Alamofire

struct RecordingsList: View {
    
	@Binding var searchKey: String
	@ObservedObject var audioRecorder: AudioRecorder = AudioRecorder.shared

    var body: some View {
        ForEach(
            searchKey.isEmpty ? audioRecorder.recordings : audioRecorder.recordings.filter {
            ($0.fileName?.contains(searchKey) ?? false) || ($0.tags.contains(searchKey) ?? false)
        }, id: \.createdAt) {
			recording in
			
			
			NavigationLink(destination: RecordingDetailView(recording: recording),
						   label: {
                RecordingRow(recording: recording).foregroundColor(.black)
					
			})
				.buttonStyle(PlainButtonStyle()).cornerRadius(10)
		}
		.onDelete(perform: delete)

		if audioRecorder.recordings.count == 0 {
			Text("모든 복습을 완료하셨습니다.").font(.title2)
		}
}


    func delete(at offsets: IndexSet) {
        var urlsToDelete = [String]()
        for index in offsets{
            urlsToDelete.append(audioRecorder.recordings[index].audioFileName)
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}

struct RecordingRow: View{
    
    var recording: Recording
    
    init(recording: Recording) {
        self.recording = recording
    }
	
	
	
	@ObservedObject var audioPlayer = AudioPlayer()
	@State private var progress:Double = 0.8 * 100.0
	
	var body: some View {
		
		HStack(alignment: .top){
			Button(action: {
					print("This is Header Icon")
				}, label: {
					Image(systemName: "repeat.circle")
						.foregroundColor(.black)
			})
			
			
			
			VStack(alignment: .leading){
				HStack{
					Text("Subject")
						.foregroundColor(.gray)
						.font(.caption)
				}
				HStack{ //HSTACK2
                    Text("\(recording.fileName ?? recording.audioFileName)")
						.font(.system(size: 15))
					Spacer()
					Text("08:01").font(.caption2)
				} // END OF HSTACK2
				HStack{ //HSTACK3
                    Text(recording.tags.reduce("", { $0 + "#\($1) "}))
						.font(.caption2)
						.foregroundColor(.gray)
				} // END OF HSTACK3
				ProgressView(value: progress, total: 100.0)
			} // END OF VSTACK
		} // END OF HSTACK
		.padding()
		.background(Color.cardViewBackground).cornerRadius(10)
		
	}
}

//
//struct RecordingsList_Previews: PreviewProvider {
//	static var previews: some View {
//		RecordingsList()
//	}
//}

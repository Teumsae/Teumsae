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
		VStack(alignment: .leading) {
			Spacer()
			
			Text("오늘의 복습")
				.font(.title)
				.padding(.trailing, 30)
			
			
            ForEach(audioRecorder.recordings, id: \.createdAt) {
                recording in
				
				
                NavigationLink(destination: RecordingView(recording: recording),
                               label: {
					RecordingRow(audioURL: recording.fileURL).foregroundColor(.black)
						
				})
//					.buttonStyle(PlainButtonStyle())
            }
            .onDelete(perform: delete)
		}
		.padding(16)
		.background(Color.cardViewBackground)
		
		
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
		
		HStack(alignment: .top){
			Button(action: {
					print("This is Header Icon")
				}, label: {
					Image(systemName: "repeat.circle")
						.foregroundColor(.black)
			}).padding()
			
			Spacer()
			
			VStack(alignment: .leading){
				HStack{
					Text("Subject")
						.foregroundColor(.gray)
						.font(.caption)
				}
				HStack{ //HSTACK2
					Text("\(audioURL.lastPathComponent)")
						.font(.caption)
					Spacer()
					Text("08:01").font(.caption2)
					Image(systemName: "chevron.forward")
				} // END OF HSTACK2
				HStack{ //HSTACK3
					Text("Tags")
						.font(.caption2)
						.foregroundColor(.gray)
				} // END OF HSTACK3
				ProgressView(value: progress, total: 100.0)
			} // END OF VSTACK
		} // END OF HSTACK
		.padding()
		.background(Color.white).cornerRadius(10)
		
	}
}


struct RecordingsList_Previews: PreviewProvider {
	static var previews: some View {
		RecordingsList()
	}
}

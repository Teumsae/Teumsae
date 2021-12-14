//
//  RecordingsList.swift
//  teumsae
//
//  Created by seungyeon on 2021/11/04.
//

import SwiftUI
import Alamofire
import RealmSwift

struct RecordingsList: View {
    
	@Binding var searchKey: String
	@ObservedObject var audioRecorder: AudioRecorder = AudioRecorder.shared
    @ObservedResults(Review.self) var reviews

    var body: some View {

        ForEach(reviews) { recording in
            NavigationLink(destination: RecordingDetailView(recording: recording), label: {
                RecordingRow(recording: recording).foregroundColor(.black)
            })
        }
        .onDelete(perform: delete)
        
        

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
    
//    var recording: Recording
//
//    init(recording: Recording) {
//        self.recording = recording
//    }
	
    @ObservedRealmObject var recording: Review
	
	@ObservedObject var audioPlayer = AudioPlayer()
	@State private var progress:Double = 0.8 * 100.0
	
	var body: some View {
        
        Text(recording.tag.value(forKey: "title") as! String)
		
//		HStack(alignment: .top){
//			Button(action: {
//					print("This is Header Icon")
//				}, label: {
//					Image(systemName: "repeat.circle")
//						.foregroundColor(.black)
//			})
//
//
//
//			VStack(alignment: .leading){
//				HStack{
//					Text("Subject")
//						.foregroundColor(.gray)
//						.font(.caption)
//				}
//				HStack{ //HSTACK2
//                    Text("\(recording.fileName ?? recording.audioFileName)")
//						.font(.system(size: 15))
//					Spacer()
//					Text("08:01").font(.caption2)
//				} // END OF HSTACK2
//
//                if let tag = recording.tag?.title {
//                    HStack{ //HSTACK3
//                        Text("#\(tag)")
//                            .font(.caption2)
//                            .foregroundColor(.gray)
//                    } // END OF HSTACK3
//
//                }
//                ProgressView(value: progress, total: 100.0)
//			} // END OF VSTACK
//		} // END OF HSTACK
//		.padding()
//		.background(Color.cardViewBackground).cornerRadius(10)
		
	}
}

//
//struct RecordingsList_Previews: PreviewProvider {
//	static var previews: some View {
//		RecordingsList()
//	}
//}

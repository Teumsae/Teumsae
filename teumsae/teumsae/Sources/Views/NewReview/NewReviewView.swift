//
//  NewReviewView.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/03.
//
// Reference: https://blckbirds.com/post/voice-recorder-app-in-swiftui-1/

import SwiftUI
import Photos
import PhotosUI


struct NewReviewView: View {
    
	@ObservedObject var audioRecorder: AudioRecorder = AudioRecorder.shared
    @StateObject var imagePicker = ImagePicker()
    @StateObject var mic: MicrophoneMonitor = MicrophoneMonitor()
    @State var title: String = ""
    @State var finishRecording = false
    @State var image: UIImage? = nil
    //@ObservedObject var audioConverter: AudioConverter
    //@State private var transcript = ""
    
    var body: some View {
        
        NavigationView { // NAVIGATION VIEW
			
				
			VStack() { // VSTACK 0
				
				NavigationLink(isActive: $finishRecording,
                               destination: { NewReviewSaveView(image: $image).environmentObject(imagePicker) },
							   label: { EmptyView() })
				
				Spacer()
				
				// MARK - TITLE AND TIMESTAMP
				VStack(alignment: .center) { // VSTACK 1
					Text("새 녹음 \(audioRecorder.recordings.count + 2)")
						.font(.title)
						.bold()
						.foregroundColor(.placeHolderGray)
					Text(Date().description)
						.font(.system(size: 16))
						.bold()
						.foregroundColor(.placeHolderGray)
				} // END OF VSTACK 1
				.padding()
				
				
				Spacer()
				
				// MARK - SOUND WAVE
				ZStack {
					Rectangle()
						.frame(height: 300)
						.foregroundColor(Color.backgroundGray)
					if audioRecorder.recording {
						SoundWaveView()
							.environmentObject(audioRecorder)
							.environmentObject(mic)
					}
				}
				.frame(height: 300)
                
                Spacer()
                                
                Button(action: { // BUTTON 0
                    if audioRecorder.recording { // IF CLAUSE 1
                        self.audioRecorder.stopRecording()
                        self.mic.stopMonitoring()
                        self.finishRecording = true
                        print("Stop recording")
                    } // ELSE CLAUSE 1
                    else {
                        self.audioRecorder.startRecording()
                        self.mic.startMonitoring()
                        print("Start recording")
                    } // END OF IF CLAUSE 1
                    
                }, label: {
                    Image(systemName: audioRecorder.recording ? "stop.fill" : "circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipped()
                        .foregroundColor(.red)
                        .padding(.bottom, 40)
                }) // END OF BUTTON 0
                
                Spacer()
                
            } // END OF VSTACK
           
        } // END OF NAVIGATION VIEW
        .navigationBarTitle("")
       .navigationBarHidden(true)
       .sheet(isPresented: $imagePicker.showImagePicker, content: {
           PhotoPicker(sourceType: .photoLibrary) { image in
               self.image = image
               print("IMAGE \(image)")
           }
           
       })

    }
}

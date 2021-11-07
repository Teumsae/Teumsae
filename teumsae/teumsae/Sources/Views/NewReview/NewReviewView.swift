//
//  NewReviewView.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/03.
//
// Reference: https://blckbirds.com/post/voice-recorder-app-in-swiftui-1/

import SwiftUI

struct NewReviewView: View {
    
	@ObservedObject var audioRecorder: AudioRecorder = AudioRecorder.shared
    @StateObject var mic: MicrophoneMonitor = MicrophoneMonitor()
    @State var title: String = ""
    //@ObservedObject var audioConverter: AudioConverter
    //@State private var transcript = ""
    
    var body: some View {
        VStack() { // VSTACK 0
            
            Spacer()
            
            // MARK - TITLE AND TIMESTAMP
            VStack(alignment: .center) { // VSTACK 1
                Text("새 복습")
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
            
        } // END OF VSTACK 0
        .navigationBarTitle("Voice recorder")
        .navigationBarItems(trailing: EditButton()) //TODO - will be deprecated
        .onChange(of: audioRecorder.audioRecorder?.currentTime, perform: { value in
            print(value)
        })
    }
}

struct NewReviewView_Previews: PreviewProvider {
    static var previews: some View {
		NewReviewView().environmentObject(AudioRecorder())
    }
}

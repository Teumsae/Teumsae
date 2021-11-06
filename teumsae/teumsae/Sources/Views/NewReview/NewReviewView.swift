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
    //@ObservedObject var audioConverter: AudioConverter
    //@State private var transcript = ""
    
    var body: some View {
            VStack { // VSTACK 0
                if audioRecorder.recording == false { // IF1 : START RECORDING
                    Button(action: {
                        self.audioRecorder.startRecording()
                        self.mic.startMonitoring()
                        print("Start recording")
                    }) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                            .foregroundColor(.red)
                            .padding(.bottom, 40)
                    }
					
                }
                else { // IF1-ELSE : STOP RECORDING
                  
                  VStack {
                      Button(action: {
                        self.audioRecorder.stopRecording()
                        self.mic.stopMonitoring()
                        print("Stop recording")
                      }) {
                        Image(systemName: "stop.fill")
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          .frame(width: 100, height: 100)
                          .clipped()
                          .foregroundColor(.red)
                          .padding(.bottom, 40)
                      }
                      Spacer()
                      SoundWaveView()
                        .environmentObject(audioRecorder)
                        .environmentObject(mic)
                   }.fixedSize(horizontal: false, vertical: true).frame( height: 450)

                } // END OF IF1 CLAUSE
            } // END OF VSTACK 0
                .navigationBarTitle("Voice recorder")
                .navigationBarItems(trailing: EditButton()) //TODO - will be deprecated
    }
}

struct NewReviewView_Previews: PreviewProvider {
    static var previews: some View {
		NewReviewView().environmentObject(AudioRecorder())
    }
}

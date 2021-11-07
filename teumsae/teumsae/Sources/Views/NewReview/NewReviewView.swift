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
    
    var body: some View {
        
        VStack(spacing: 20) { // VSTACK 0
            if audioRecorder.recording || audioRecorder.saving { // IF CLAUSE 0
                VStack { // VSTACK 1
                    ZStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                
                            }, label: {
                                Text("완료")
                            })
                        }
                        HStack {
                            Spacer()
                            TextField("새 녹음1", text: $title)
                                .font(.title)
                                .multilineTextAlignment(TextAlignment.center)
                            Spacer()
                        }
                        
                    }
                    
                    VStack { // VSTACK 2
                        Spacer()
                        SoundWaveView()
                            .frame(height: 300)
                            .background(Color.waveBackgroundGray)
                            .environmentObject(audioRecorder)
                            .environmentObject(mic)
                        Spacer()
                    } // END OF VSTACK 2
                    
                    
                } // END OF VSTACK 1
            }
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
        } // END OF VSTACK 0
        .padding([.leading, .trailing, .bottom])
        .ignoresSafeArea(.keyboard)
        .navigationBarTitle("Voice recorder")
        .navigationBarItems(trailing: EditButton()) //TODO - will be deprecated
    }
}


//
//  RecordingView.swift
//  teumsae
//
//  Created by 오수민 on 2021/11/06.
//

import Foundation
import SwiftUI
import AVKit

struct RecordingView: View {
    
    let recording: Recording
    @ObservedObject var audioPlayer = AudioPlayer()
//    @State var player : AVAudioPlayer!

    @State var data : Data = .init(count: 0)
    //@State var title = ""
    @State var playing = false
    @State var width : CGFloat = 0
    //@State var songs = ["black","bad"]
    @State var current = 0
    @State var finish = false
    @State var duration = TimeInterval(0)
    @State var currentTime = TimeInterval(0)
//    @State var del = AVdelegate()
    
    
    init (recording: Recording) {
        self.recording = recording
    }
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(recording.fileName ?? "<no_name>")
//                    .font(.headline)
                    .font(.system(size:30))
                    .frame(height: 43, alignment: .leading)
                    .padding(.leading, 17)
                    //.padding(.top, 17)
                Text("Date")
                    .font(.headline)
                    .font(.system(size:17))
                    .frame(height: 23, alignment: .leading)
                    .padding(.leading, 17)
                Text(recording.createdAt.toString(dateFormat: "yyyy-MM-dd HH:mm"))
                    .font(.headline)
                    .frame(height: 23)
                    //.padding(.top, 104)
                    .padding(.leading, 17)
                    
                    
                    ZStack(alignment: .leading) {
                    
                        Capsule().fill(Color.black.opacity(0.08)).frame(height: 8)
                        
                        Capsule().fill(Color.yellow).frame(width: self.width, height: 8)
                        .gesture(DragGesture()
                            .onChanged({ (value) in
                                let x = value.location.x
                                self.width = x
                            }).onEnded({ (value) in
                                let x = value.location.x

                                let screen = UIScreen.main.bounds.width
                                let percent = x / screen
                                self.audioPlayer.audioPlayer.currentTime = Double(percent) * self.audioPlayer.audioPlayer.duration
                                self.currentTime =  self.audioPlayer.audioPlayer.currentTime
                            }))
                    }
                    .padding(.top)
                    .padding(.leading, 17)
                    .padding(.trailing, 17)
                    
                HStack{
                            Spacer()
                            Button(action: {
                                self.audioPlayer.audioPlayer.currentTime -= 15
                            }) {
                                Image(systemName: "gobackward.15").font(.title)
                            }
                        
                            Button(action: {
                                if self.audioPlayer.isPlaying{
                                    self.audioPlayer.stopPlayback()
                                    self.playing = false
                                }
                                else {
                                    if self.finish {
                                        self.audioPlayer.audioPlayer.currentTime = 0
                                        self.width = 0
                                        self.finish = false
                                        
                                    }
                                    self.audioPlayer.startPlayback(audio: self.recording.fileURL)
                                    self.playing = true
                                }
                                
                            }) {
                                Image(systemName: self.playing && !self.finish ? "pause.fill" : "play.fill").font(.title)
                            }
                    Button(action: {
                                                  
                                                   let increase = self.audioPlayer.audioPlayer.currentTime + 5
                                                   
                                                   if increase < self.audioPlayer.audioPlayer.duration{
                                                       
                                                       self.audioPlayer.audioPlayer.currentTime = increase
                                                   }
                                                   
                                               }) {
                                           
                                                   Image(systemName: "goforward.5").font(.title)
                                                   
                                               }
                        

                            Button(action: {
                                let increase = self.audioPlayer.audioPlayer.currentTime + 15
                                if increase < self.audioPlayer.audioPlayer.duration {
                                    self.audioPlayer.audioPlayer.currentTime = increase
                                }
                            }) {
                                Image(systemName: "goforward.15").font(.title)
                            }
                            Spacer()
                    }.padding(.top,25)
                    .foregroundColor(.black)

                Divider()
                
                Text(recording.transcription ?? "<no_transcription>")
                    .padding(.leading, 17)
            }
            .onAppear {
                self.audioPlayer.audioPlayer = try! AVAudioPlayer(contentsOf: self.recording.fileURL)
                
                self.audioPlayer.audioPlayer.delegate = self.audioPlayer
                
                self.audioPlayer.audioPlayer.prepareToPlay()
                
                self.duration = self.audioPlayer.audioPlayer.duration
                

                Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (_) in

                    if self.audioPlayer.audioPlayer.isPlaying{

                        let screen = UIScreen.main.bounds.width - 34

                        let value = self.audioPlayer.audioPlayer.currentTime / self.audioPlayer.audioPlayer.duration

                        self.width = screen * CGFloat(value)
                        self.currentTime =  self.audioPlayer.audioPlayer.currentTime
                    }
                }
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("Finish"), object: nil, queue: .main) { (_) in
                    
                    self.finish = true
                }
            }
            
            .frame(
                  minWidth: 0,
                  maxWidth: .infinity,
                  minHeight: 0,
                  maxHeight: .infinity,
                  alignment: .topLeading
                )
            
        }
    }
}



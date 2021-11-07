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

    @State var data : Data = .init(count: 0)
    //@State var title = ""
    @State var playing = false
    @State var width : CGFloat = 0
    //@State var songs = ["black","bad"]
    @State var current = 0
    @State var finish = false
    @State var del = AVdelegate()
    
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
                        
                        Capsule().fill(Color.red).frame(width: self.width, height: 8)
                        .gesture(DragGesture()
                            .onChanged({ (value) in
                                
                                let x = value.location.x
                                
                                self.width = x
                                
                            }).onEnded({ (value) in
                                
                                let x = value.location.x
                                
                                let screen = UIScreen.main.bounds.width-30
                                
                                let percent = x / screen
                                
                                self.audioPlayer.audioPlayer.currentTime = Double(percent) * self.audioPlayer.audioPlayer.duration
                            }))
                    }
                    .padding(.top)
                    
                HStack{
                        
//                        Button(action: {
//
//                            if self.current > 0{
//
//                                self.current -= 1
//
//                                //self.ChangeSongs()
//                            }
//
//                        }) {
//
//                            Image(systemName: "backward.fill").font(.title)
//
//                        }
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
                                else{
                                    
                                    if self.finish{
                                        
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
                               
                                let increase = self.audioPlayer.audioPlayer.currentTime + 15
                                
                                if increase < self.audioPlayer.audioPlayer.duration{
                                    
                                    self.audioPlayer.audioPlayer.currentTime = increase
                                }
                                
                            }) {
                        
                                Image(systemName: "goforward.15").font(.title)
                                
                            }
                            Spacer()
                        
//                            Button(action: {
//
//                                if self.songs.count - 1 != self.current{
//
//                                    self.current += 1
//
//                                    //self.ChangeSongs()
//                                }
//
//                            }) {
//
//                                Image(systemName: "forward.fill").font(.title)
//
//                            }
                        
                    }.padding(.top,25)
                    .foregroundColor(.black)

                Divider()
                
                Text(recording.transcription ?? "<no_transcription>")
                    .padding(.leading, 17)
            }
            .onAppear {
                
                self.audioPlayer.audioPlayer = try! AVAudioPlayer(contentsOf: self.recording.fileURL)
                
                self.audioPlayer.audioPlayer.delegate = self.del
                

                Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (_) in

                    if self.audioPlayer.audioPlayer.isPlaying{

                        let screen = UIScreen.main.bounds.width - 30

                        let value = self.audioPlayer.audioPlayer.currentTime / self.audioPlayer.audioPlayer.duration

                        self.width = screen * CGFloat(value)
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

class AVdelegate : NSObject,AVAudioPlayerDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        NotificationCenter.default.post(name: NSNotification.Name("Finish"), object: nil)
    }
}

//struct RecordingView_Previews: PreviewProvider {
//    static var previews: some View {
//        let dateString = "2019-05-19"
//        RecordingView(recording:Recording(
//            fileURL: URL(string: "recordings/2"),
//            createdAt: dateString.toDate(),
//            transcript: "Darla, would you like to start today? Sure, yesterday I reviewed Luis' PR and met with the design team to finalize the UI..."))
//       }
//}


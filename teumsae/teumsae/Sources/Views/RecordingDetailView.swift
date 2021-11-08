//
//  RecordingDetailView.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/07.
//

import SwiftUI
import AVKit

struct RecordingDetailView: View {
    
    
    var recording: Recording = Recording(audioFileName: "07-11-21_at_20:24:37.wav", createdAt: Date(), fileName: "제목", lastPlay: nil, image: UIImage(named: "dummyImage"), transcription: "transcription", reviewCount: 2, tags: ["tag1", "tag2"])
    
    
    // AUDIO PLAYER
    @ObservedObject var audioPlayer = AudioPlayer()
    @State var data : Data = .init(count: 0)
    @State var playing = false
    @State var width : CGFloat = 0
    @State var current = 0
    @State var finish = false
    @State var del = AVdelegate()
    
    init() {
        if let rec = AudioRecorder.shared.lastRecoreding {
            self.recording = rec
        }
    }
    
    init(recording: Recording) {
        self.recording = recording
    }
    
    var body: some View {
        
        ScrollView { // SCROLL VIEW
            
            VStack(alignment: .leading) { // VSTACK 0
                
                // MARK - TITLE
                HStack(alignment: .center) { // HSTACK 0
                    if let title = recording.fileName {
                        Text(title)
                            .bold()
                            .font(.system(size: 30))
                    }
                    
                    Spacer()
                    
                    Text("\(recording.reviewCount > 3 ? 3 : recording.reviewCount)/3")
                        .bold()
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .padding([.leading, .trailing], 10)
                        .padding([.top, .bottom], 3)
                        .background(Color.mainYellow)
                        .cornerRadius(10)
                    
                } // END OF HSTACK 0
                
                // MARK - TIME STAMP
                Text(recording.timeStamp)
                    .bold()
                    .font(.system(size: 16))
                
                // MARK - TAGS
                FlexibleView(data: recording.tags, spacing: 8, alignment: .leading, content: { item in
                    Text(item)
                        .bold()
                        .font(.system(size: 14))
                        .foregroundColor(.mainYellow)
                        .padding([.leading, .trailing], 10)
                        .padding([.top, .bottom], 3)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.mainYellow, lineWidth: 1))
                    
                })
                
                // MARK - IMAGE
                if let image = recording.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                // MARK - PLAYER
                HStack(alignment: .center) { // HSTACK PLAYER
                    
                    // MARK - BUTTONS
                    Button(action: {
                        if self.audioPlayer.isPlaying {
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
                        Image(systemName: self.playing && !self.finish ? "pause.fill" : "play.fill")
                            .foregroundColor(Color.black)
                    }
                    
                    Button(action:{
                                self.audioPlayer.audioPlayer.currentTime -= 15
                            }) {
                                Image(systemName: "gobackward.15")
                                    .foregroundColor(Color.black)
                            }
                
                    Button(action: {
                        let increase = self.audioPlayer.audioPlayer.currentTime + 15
                        if increase < self.audioPlayer.audioPlayer.duration {
                            self.audioPlayer.audioPlayer.currentTime = increase
                        }
                    }) {
                        Image(systemName: "goforward.15")
                            .foregroundColor(Color.black)
                    }
                    
                    
                    // MARK  - PLAYER BAR
                    VStack { // VSTACK PLAYER BAR
                        Spacer()
                        ZStack(alignment: .leading) { // ZSTACK PLAYER BAR
                        
                            Capsule().fill(Color.black.opacity(0.08)).frame(height: 8)
                            Capsule().fill(Color.mainYellow).frame(width: self.width, height: 8)
                            .gesture(DragGesture()
                                        .onChanged({ value in
                                let x = value.location.x
                                self.width = x
                                    })
                                        .onEnded({ value in
                                    let x = value.location.x
                                    let screen = UIScreen.main.bounds.width
                                    let percent = x / screen
                                    self.audioPlayer.audioPlayer.currentTime = Double(percent) * self.audioPlayer.audioPlayer.duration
                                }))
                        } // END OF ZSTACK PLAYER BAR
                        Spacer()
                    } // END OF VSTACK PLAYER BAR
                } // END OF HSTACK PLAYER
            
                // MARK - TRANSCRIPTION
                if let transcription = recording.transcription {
                    Text(transcription)
                        .padding()
                        .frame(
                              maxWidth: .infinity,
                              alignment: .topLeading
                            )
                        .background(Color.backgroundGray)
                        .cornerRadius(8)
                }

            } // END OF VSTACK 0
            .padding([.top], 10)
            .padding([.leading, .trailing], 20)
            .navigationBarTitle(recording.fileName ?? recording.audioFileName, displayMode: .inline)
            
            
        } // END OF SCROLL VIEW
        .onAppear {
            
            self.audioPlayer.audioPlayer = try! AVAudioPlayer(contentsOf: self.recording.fileURL)
            self.audioPlayer.audioPlayer.delegate = self.del

            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (_) in
                if self.audioPlayer.audioPlayer.isPlaying {
                    let screen = UIScreen.main.bounds.width - 30
                    let value = self.audioPlayer.audioPlayer.currentTime / self.audioPlayer.audioPlayer.duration
                    self.width = screen * CGFloat(value)
                }
            }
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("Finish"), object: nil, queue: .main) { _ in
                self.finish = true
            }
        }
        
    }
}


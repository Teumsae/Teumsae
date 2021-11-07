//
//  NewReviewSaveView.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/07.
//

import SwiftUI


struct NewReviewSaveView: View {
    
    @State var title: String = ""
    @State var tags: [String] = [] {
        didSet {
            tagEntry = ""
        }
    }
    @State var tagEntry: String = ""
    @ObservedObject var audioRecorder: AudioRecorder = AudioRecorder.shared
    @EnvironmentObject var imagePicker: ImagePicker
    @Binding var image: UIImage?
    @State var saved = false
    
    init(image: Binding<UIImage?>) {
        self._image = image
    }
    
    var body: some View {
        
        ScrollView { // SCROLL VIEW
            
            VStack { // VSTACK 0
                
                // MARK: Title Button
                NavigationLink(isActive: $saved, destination: {
                    RecordingDetailView()
                }, label: {
                    EmptyView()
                })
                
                HStack { // HSTACK 0
                    TextField("새 녹음 \(audioRecorder.recordings.count + 1)", text: $title)
                        .font(.system(size: 30))
                    Button(action: {
                        if let curRecording = audioRecorder.lastRecoreding {
                            
                            var recording = Recording(audioFileName: curRecording.audioFileName,
                                                      createdAt: curRecording.createdAt,
                                                      fileName: title.isEmpty ? curRecording.audioFileName : title,
                                                      image: image,
                                                      transcription: curRecording.transcription,
                                                      tags: tags)
            
                            PersistenceManager.shared.updateByFileURL(audioFileName: curRecording.audioFileName, recording: recording)
                            
                            audioRecorder.fetchRecordings()
                            saved = true
                        }
                    }, label: {
                        Text("기록 완료")
                    })
                    
                } // END OF HSTACK 0
                
                // MARK: TagView
                VStack {
                    
                    TextField("태그를 입력하세요", text: $tagEntry, onCommit: {
                        tags.append(tagEntry)
                    })
                        .padding(6)
                        .padding([.leading], 4)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.unselectedGray))
                        
                        
                    
                    if !tags.isEmpty {
                        
                        FlexibleView(data: tags, spacing: 8, alignment: .leading, content: { item in
                            Text(item)
                                .bold()
                                .font(.system(size: 14))
                                .foregroundColor(.mainYellow)
                                .padding([.leading, .trailing], 10)
                                .padding([.top, .bottom], 3)
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.mainYellow, lineWidth: 1))
                            
                        })
                        
                    }
                    
                }
                .padding(6)
                .background(Color.backgroundGray)
                .cornerRadius(8)
                
                VStack {
                    if let uiImage = self.image {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)

                    } else {
                        Image("imagePlaceholder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text("탭해서 사진을 추가하세요!")
                            .foregroundColor(Color.unselectedGray)
                        
                    }
                }
                .padding(6)
                .background(Color.backgroundGray)
                .cornerRadius(8)
                .onTapGesture {
                    imagePicker.showImagePicker = true
                }
                
                Spacer()
            } // END OF VSTACK 0
            .padding()
            .padding([.top], 10)
            
        } // END OF SCROLL VIEW
        .navigationBarTitle("")
        .navigationBarHidden(true)
        
    }
}


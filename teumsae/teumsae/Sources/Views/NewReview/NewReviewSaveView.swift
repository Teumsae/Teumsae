//
//  NewReviewSaveView.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/07.
//

import SwiftUI
import RealmSwift


struct NewReviewSaveView: View {
    
    @State var title: String = ""
    @State var tagEntry: String = ""
    @ObservedObject var audioRecorder: AudioRecorder = AudioRecorder.shared
    @EnvironmentObject var imagePicker: ImagePicker
    @Binding var image: UIImage?
    @State var saved = false
    @State var isExpanded = false
    @State var transcription = ""
    @State var score: Int = 3
    var intProxy: Binding<Double>{
            Binding<Double>(get: {
                //returns the score as a Double
                return Double(score)
            }, set: {
                //rounds the double to an Int
                print($0.description)
                score = Int($0)
            })
        }
    
    @ObservedResults(TagNotificationGroup.self) var tagGroups
    @ObservedResults(Review.self) var reviews
  
    
    init(image: Binding<UIImage?>) {
        UINavigationBar.appearance().tintColor = UIColor(Color.mainYellow)
        UITextView.appearance().backgroundColor = .clear
        self._image = image
        self.transcription = reviews.last?.transcription ?? ""
    }
    
    var body: some View {
      
      ZStack {
        
        ScrollView { // SCROLL VIEW
            
            VStack { // VSTACK 0
                
                // MARK: Title Button
                NavigationLink(isActive: $saved, destination: {
                    RecordingDetailView(recording: reviews.last!)
                }, label: {
                    EmptyView()
                })
                
                GroupBox(
                       label: Label("TITLE", systemImage: "book.closed.fill")
                           .foregroundColor(.mainYellow)
                   ) {
                       TextField("새 녹음 \(reviews.count + 1)", text: $title)
                           .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 24))
                           .foregroundColor(.subBlack)
                }
                
                GroupBox(
                       label: Label("TAG", systemImage: "tag.fill")
                           .foregroundColor(.mainYellow)
                   ) {
                       DisclosureGroup("\(tagEntry.isEmpty ? "Select a tag" : tagEntry)", isExpanded: $isExpanded, content: {
                           VStack {
                               

                               ForEach(tagGroups.first!.notifications) { tag in
                                   HStack {
                                       Text(tag.title)
                                           .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 15))
                                       Spacer()
                                   }
                                   .padding([.top, .bottom], 3)
                                   .padding([.leading, .trailing], 10)
                                   .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 12))
                                   .onTapGesture {
                                       self.tagEntry = tag.title
                                       withAnimation {
                                           self.isExpanded.toggle()
                                       }
                                   }
                               }
                               .padding([.top, .bottom], 3)
                               NavigationLink(destination: NewTagNotificationView().padding()) {
                                   HStack {
                                       Text("+ Add tag")
                                           .foregroundColor(.secondary)
                                           .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 15))
                                       Spacer()
                                   }
                                   .padding([.top, .bottom], 3)
                                   .padding([.leading, .trailing], 10)
                                   .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 12))
                               }
                              
                               
                               
                           }
                       }) // END OF DISCLOSURE GROUP
                           .accentColor(.yellow)
                           .foregroundColor(.yellow)
                           .padding([.top, .bottom], 5)
                           .padding([.leading, .trailing], 10)
                           .background(Color.white)
                           .cornerRadius(8)
                }
                
                GroupBox(
                       label: Label("GOAL", systemImage: "brain.head.profile")
                           .foregroundColor(.mainYellow)
                   ) {
                       HStack {
                           Slider(value: intProxy , in: 0.0...5.0, step: 1.0, onEditingChanged: {_ in
                                           print(score.description)
                                       })
                           Text("\(score)")
                               .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 18))
                               .foregroundColor(.subBlack)
                       }
                       
                }
                   .accentColor(.yellow)
                   
                
                
                GroupBox(
                       label: Label("IMAGE", systemImage: "photo")
                           .foregroundColor(.mainYellow)
                   ) {
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
                       .onTapGesture {
                           imagePicker.showImagePicker = true
                       }
                }
                
                GroupBox(
                       label: Label("TRANSCRIPTION", systemImage: "text.append")
                           .foregroundColor(.mainYellow)
                   ) {
                       TextEditor(text: $transcription)
                           .font(Font.custom("AppleSDGothicNeo-Regular", fixedSize: 16))
                           .foregroundColor(.subBlack)
                       
                }
                
                Spacer()
            } // END OF VSTACK 0
            .padding()
            .padding([.top], 10)
            
        } // END OF SCROLL VIEW
        .navigationBarItems(trailing: Button(action: {
            
            
            if let recording = reviews.last?.thaw() {
                let realm = try! Realm()
                

                try! realm.write {
                    recording.fileName = self.title.isEmpty ? "새 녹음 \(reviews.count + 1)" : title
                    recording.image = self.image?.jpegData(compressionQuality: 0.9)
                    recording.reviewGoal = self.score
                    if let tagRealm = realm.objects(TagNotification.self).filter("title == \"\(self.tagEntry)\"").first {
                        tagRealm.reviews.append(recording)
                    } else {
                        realm.objects(TagNotification.self).filter("title == \"Unfiled\"").first?.reviews.append(recording)
                    }
                        
                    
                }
            }
            
            saved = true

            
        }, label: {
            Text("Done")
        }))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("새 녹음")
        
        
        if self.audioRecorder.audioConverter.isLoading {
              CustomProgressiveView(msg: "Transcripting...")
                .onDisappear {
                    transcription = reviews.last?.transcription ?? ""
                    print("LAST REVIEW \(reviews.last)")
                }
          }
        
    }
        
//      .navigationBarHidden(true)
        
        
   
    }
}


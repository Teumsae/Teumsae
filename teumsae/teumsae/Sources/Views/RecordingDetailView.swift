//
//  RecordingDetailView.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/07.
//

import SwiftUI

struct RecordingDetailView: View {
    
    let recording: Recording = Recording(audioFileName: "07-11-21_at_20:24:37.wav", createdAt: Date(), fileName: "제목", lastPlay: nil, image: UIImage(named: "dummyImage"), transcription: "transcription", reviewCount: 2, tags: ["tag1", "tag2"])
    
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
                }
                
                // MARK - PLAYER
                
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
            .padding(20)
            
            
        } // END OF SCROLL VIEW
        
    }
}


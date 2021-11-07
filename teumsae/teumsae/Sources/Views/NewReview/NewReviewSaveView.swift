//
//  NewReviewSaveView.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/07.
//

import SwiftUI

struct NewReviewSaveView: View {
    
    @State var title: String = ""
    @State var tags: [String] = []
    @State var tagEntry: String = ""
    @ObservedObject var audioRecorder: AudioRecorder = AudioRecorder.shared
    
    var body: some View {
        VStack { // VSTACK 0
            
            // MARK: Title Button
            HStack { // HSTACK 0
                TextField("새 녹음 \(audioRecorder.recordings.count + 1)", text: $title)
                    .font(.system(size: 30))
                Button(action: {
                    
                }, label: {
                    Text("기록 완료")
                })
                
            } // END OF HSTACK 0
            
            
            
            FlexibleView(data: tagEntry, spacing: 8, alignment: .leading, content: { item in
                Text(item)
                    .bold()
                    .font(.system(size: 14))
                    .foregroundColor(.mainYellow)
                    .padding([.leading, .trailing], 10)
                    .padding([.top, .bottom], 3)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.mainYellow, lineWidth: 1))
                
            })
            
            
            
            
            Spacer()
        } // END OF VSTACK 0
        .padding()
    }
}


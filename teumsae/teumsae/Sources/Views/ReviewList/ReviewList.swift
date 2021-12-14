//
//  ReviewList.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/06.
//

import SwiftUI
import RealmSwift


struct ReviewList: View {
    
    @ObservedResults(TagNotificationGroup.self) var tagGroups
    @ObservedResults(Review.self) var reviews
    @State var progress: Double = 0
    
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                VStack {

                    ForEach(tagGroups.first!.notifications) { tag in
                        
                        DisclosureGroup(content: {
                            ForEach(tag.reviews) { review in
                                NavigationLink(destination: RecordingDetailView(recording: review) ) {
                                    VStack {
                                        HStack {
                                            Image(systemName: "pencil")
                                                .renderingMode(.template)
                                            Text(review.fileName ?? review.audioFileName)
                                                .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 16))
                                
                                            Spacer()
                                            
                                            Text("\(review.reviewCount) / \(review.reviewGoal)")
                                                .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 12))
                                                .bold()
                                                .foregroundColor(.white)
                                                .padding([.leading, .trailing], 8)
                                                .padding([.top, .bottom], 3)
                                                .background(Color.mainYellow)
                                                .cornerRadius(10)
                                        }
                                        
                                        HStack {
                                            Text("\(secToHMS(Int(Double(review.totalLength) * review.percent)))")
                                                .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 12))
                                                .bold()
                                                .foregroundColor(.subBlack)
                                            
                                            ProgressView(value: progress).onAppear {
                                                progress = review.percent
                                            }
                                            
                                            Text("\(secToHMS(review.totalLength))")
                                                .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 12))
                                                .bold()
                                                .foregroundColor(.subBlack)
                                
                                        }
                                        
                                        
                                    }
                                    
                                    .padding(8)
                                    .background(Color(UIColor.white))
                                    .foregroundColor(Color.mainYellow)
                                    .cornerRadius(8)
                                }
                                
                            }
                            .padding([.leading], 10)
                        }, label: {
                            GroupBox(
                                label: Label("\(tag.title)", systemImage: "folder.fill")
                                       .foregroundColor(.mainYellow)
                               ) {
                                   HStack {
                                       Text(tag.reviews.count > 0 ? "\(tag.reviews.last?.fileName ?? tag.reviews.last!.audioFileName) 외 \(tag.reviews.count - 1)개" : " ")
                                           .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 14))
                                           .foregroundColor(.subBlack)
                                       Spacer()
                                   }
                                   .padding(.top, 3)
                                   
                            }
                            .background(Color(UIColor.systemGray6))
                        })
                        .accentColor(.mainYellow)
                        .padding([.trailing], 10)
                        .padding([.bottom], 10)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .listRowSeparator(.hidden)
                       
                    }
                    
                }
                .padding()
                
            }
            .navigationBarTitle("틈새복습")
            
        }
        
        
        
            
    }
    
    func secToHMS(_ seconds: Int) -> String {
        let hr = seconds / 3600
        if hr > 0 {
            return String(format: "%02d:%02d:%02d", seconds / 3600, seconds % 3600 / 60, ((seconds % 3600) % 60))
        }
        else {
            return String(format: "%02d:%02d", seconds % 3600 / 60, ((seconds % 3600) % 60))
        }
    }
    


    
}

//struct ReviewList: View {
//
//	@State var searchKey: String = ""
//
//    var body: some View {
//		NavigationView { // NAVIGATION VIEW
//			List{
//				Section(header: Text("복습하기")
//							.font(.title3).foregroundColor(.black)
//							.padding(.bottom, 5)
//							){
//					RecordingsHeaderCardView(searchKeyOnCommit: $searchKey).cornerRadius(10)
//				}
//
//					.buttonStyle(.plain)
//
//
//
//				Section(header:Text("오늘의 복습").font(.title3).foregroundColor(.black).padding(.bottom, 5)){
//					RecordingsList(searchKey: $searchKey)
//				}
//			}
//
//        } // END OF NAVIGATION VIEW
//    }
//}
//



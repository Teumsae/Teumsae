//
//  SearchView.swift
//  teumsae
//
//  Created by subeen on 2021/12/15.
//

import SwiftUI
import RealmSwift

struct SearchView: View {
    
    @State var queryString: String = ""
//    @ObservedResults(Review.self, sortDescriptor: SortDescriptor(keyPath: "createdAt", ascending: false)) var reviews
    static let realm = try! Realm()
    @State var reviews = SearchView.realm.objects(Review.self)
    
//    @State var reviews: Link<Result<Review>> = {
//        let realm = try! realm
//        return realm.objects(Review.self)
//    }()
    
    var body: some View {
        NavigationView {

            List {

                
                ForEach(reviews) { review in
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .center) {
                            Image(systemName: "book.closed.fill")
                                .foregroundColor(.mainYellow)
                            Text(review.tag.first?.title ?? "빈 제목")
                                .font(Font.custom("AppleSDGothicNeo-Bold", fixedSize: 16))
                                .foregroundColor(.mainYellow)
                            
                            Spacer()
                            Text("\(review.timeStamp)")
                                .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 12))
                                .foregroundColor(Color(UIColor.systemGray2))
                        }
                        Text("\(review.fileName ?? review.audioFileName)")
                            .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 16))
                            .foregroundColor(.black)
                        if let transcription = review.transcription {
                            HStack {
                                Text(transcription)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                    .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 15))
                                    .foregroundColor(.subBlack)
                            }
                        }
                    }
                    .padding()
                    .background(Color.searchBarGray)
                    .cornerRadius(8)
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationBarTitle("Search", displayMode: .large)
        }
        .searchable(text: $queryString, placement: .navigationBarDrawer(displayMode: .always), prompt: "파일명, 제목 또는 글을 검색하세요")
        .onChange(of: queryString, perform: { queryString in
            
            if !queryString.isEmpty {
                reviews = SearchView.realm.objects(Review.self).filter("fileName CONTAINS[c] %@ OR transcription CONTAINS[c] %@ OR audioFileName CONTAINS[c] %@", queryString, queryString, queryString)
                print("\(queryString) : \(reviews.count)")
            } else {
                reviews = SearchView.realm.objects(Review.self)
            }
            
            
        })
        
    }
    
    
}


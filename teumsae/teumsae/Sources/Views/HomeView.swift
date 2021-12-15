//
//  HomeView.swift
//  teumsae
//
//  Created by subeen on 2021/12/15.
//


import SwiftUI
import RealmSwift


struct HomeView: View {
    
    @State var hourReviews = SearchView.realm.objects(Review.self).filter("createdAt >= %@", Calendar.current.date(byAdding: .hour, value: -1, to: Date()))
    @State var dayReviews = SearchView.realm.objects(Review.self).filter("createdAt <= %@ AND createdAt >= %@", Calendar.current.date(byAdding: .hour, value: -1, to: Date()), Calendar.current.date(byAdding: .day, value: -1, to: Date()))
    @State var weekReviews = SearchView.realm.objects(Review.self).filter("createdAt <= %@ AND createdAt >= %@", Calendar.current.date(byAdding: .day, value: -1, to: Date()), Calendar.current.date(byAdding: .day, value: -7, to: Date()))
    
    
    @ObservedResults(LocationNotificationGroup.self) var locationGroups
    @ObservedResults(TimeNotificationGroup.self) var timeGroups
    @ObservedResults(TagNotificationGroup.self) var tagGroups
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font : UIFont(name: "AppleSDGothicNeo-Bold", size: 32)!,
            .foregroundColor: UIColor(Color.mainYellow)]
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().backgroundColor = .clear
//        UITableView.appearance().separatorStyle = UIColor(Color.clear)
        UITableViewHeaderFooterView.appearance().tintColor = UIColor(Color.badgeTextGray)
        UINavigationBar.appearance().tintColor = UIColor(Color.mainYellow)
    }
    
    
    
    var body: some View {
        NavigationView {
 
            List {
                
                VStack(spacing: 5) {
                    HStack {
                        GroupBox(
                            label: Label("GOAL", systemImage: "clock")
                                .font(Font.custom("AppleSDGothicNeo-Bold", fixedSize: 14))
                                .foregroundColor(.orange)
                        ) {
                            Text("\(getTotalTime())")
                                .font(Font.custom("AppleSDGothicNeo-Bold", fixedSize: 18))
                                .padding(3)
                                .foregroundColor(.subBlack)
                        }
                        GroupBox(
                            label: Label("THIS WEEK", systemImage: "flame")
                                .font(Font.custom("AppleSDGothicNeo-Bold", fixedSize: 14))
                                .foregroundColor(.orange)
                        ) {
                            Text("\(getPlayTime())")
                                .font(Font.custom("AppleSDGothicNeo-Bold", fixedSize: 18))
                                .padding(3)
                                .foregroundColor(.subBlack)
                        }
                    }
                    .listRowSeparator(.hidden)
                    GroupBox(
                        label: Label("AVERAGE", systemImage: "heart.fill")
                            .font(Font.custom("AppleSDGothicNeo-Bold", fixedSize: 14))
                            .foregroundColor(.orange)
                    ) {
                        HStack {
                            Text("📚 \(Int(round(getPercentage())))% of the total goal!! 📚")
                            Spacer()
                        }
                        .font(Font.custom("AppleSDGothicNeo-Bold", fixedSize: 18))
                        .padding(3)
                        .foregroundColor(.subBlack)
                        
                    }
                    .listRowSeparator(.hidden)
                }
                .padding()
                .background(Rectangle()
                                .strokeBorder(style: StrokeStyle(lineWidth: 4, dash: [10]))
                                .foregroundColor(.mainYellow))
                
                
                Section(content: {
                    ForEach(hourReviews) { item in
                        HStack {
                            NavigationLink {
                                RecordingDetailView(recording: item)
                            } label: {
                                    HStack(alignment: .center) {
                                        Image(systemName: item.reviewCount > 0 ? "checkmark.square" : "square")
                                        
                                            .foregroundColor(.mainYellow)
                                        Text("\(item.fileName ?? item.audioFileName)")
                                            .font(Font.custom("AppleSDGothicNeo-Bold", fixedSize: 14))
                                            .strikethrough(item.reviewCount > 0)
                                            .foregroundColor(.mainYellow)
                                        Text(item.tag.first?.title ?? "빈 제목")
                                            .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 12))
                                            .foregroundColor(Color(uiColor: UIColor.systemGray3))
                                    }
                            }

                        }
                        .listRowSeparator(.hidden)
                    }
//                    .onDelete(perform: $group.notifications.remove)
//                    .onMove(perform: $group.notifications.move)
                }, header: {
                    HStack{
                        Text("🔥 An Hour Ago")
                            .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 20))
                        Text("\(hourReviews.count)")
                            .font(Font.custom("AppleSDGothicNeo-Bold", fixedSize: 14))
                            .padding([.leading, .trailing], 6)
                            .padding([.top, .bottom], 3)
                            .foregroundColor(Color.badgeTextGray)
                            .background(RoundedRectangle(cornerRadius: 6).fill(Color.badgeBackgroundGray))
                        Spacer()
                    }
                    .foregroundColor(.gray)
                })
                
                Section(content: {
                    ForEach(dayReviews) { item in
                        HStack {
                            NavigationLink {
                                RecordingDetailView(recording: item)
                            } label: {
                                Image(systemName: Double(item.reviewCount/item.reviewGoal) >= 0.5 ? "checkmark.square" : "square")
                                    .foregroundColor(.mainYellow)
                                Text("\(item.fileName ?? item.audioFileName)")
                                    .strikethrough(Double(item.reviewCount/item.reviewGoal) >= 0.5)
                                    .lineLimit(1)
                                    .font(Font.custom("AppleSDGothicNeo-Bold", fixedSize: 14))
                                    .foregroundColor(.mainYellow)
                                            
                                
                                        Text(item.tag.first?.title ?? "빈 제목")
                                            .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 12))
                                            .foregroundColor(Color(uiColor: UIColor.systemGray3))
    
                                          
                            }
                        }
                        .listRowSeparator(.hidden)
                    }

                }, header: {
                    HStack{
                        Text("🔥 A Day Ago")
                            .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 20))
                        Text("\(dayReviews.count)")
                            .font(Font.custom("AppleSDGothicNeo-Bold", fixedSize: 14))
                            .padding([.leading, .trailing], 6)
                            .padding([.top, .bottom], 3)
                            .foregroundColor(Color.badgeTextGray)
                            .background(RoundedRectangle(cornerRadius: 6).fill(Color.badgeBackgroundGray))
                        Spacer()
                    }
                    .foregroundColor(.gray)
                })
                
                Section(content: {
                    ForEach(weekReviews) { item in
                        HStack {
                            NavigationLink {
                                RecordingDetailView(recording: item)
                            } label: {
                                    HStack(alignment: .center) {
                                        Image(systemName: item.reviewCount == item.reviewGoal ? "checkmark.square" : "square")
                                            .foregroundColor(.mainYellow)
                                        Text("\(item.fileName ?? item.audioFileName)")
                                            .font(Font.custom("AppleSDGothicNeo-Bold", fixedSize: 14))
                                            .strikethrough(item.reviewCount == item.reviewGoal)
                                            .foregroundColor(.mainYellow)
                                            .lineLimit(1)
                                        
                                        Text(item.tag.first?.title ?? "빈 제목")
                                            .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 12))
                                            .foregroundColor(Color(uiColor: UIColor.systemGray3))
                                          
                                    }
                            }

                        }
                        .listRowSeparator(.hidden)
                    }

                }, header: {
                    HStack{
                        Text("🔥 A Week Ago")
                            .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 20))
                        Text("\(weekReviews.count)")
                            .font(Font.custom("AppleSDGothicNeo-Bold", fixedSize: 14))
                            .padding([.leading, .trailing], 6)
                            .padding([.top, .bottom], 3)
                            .foregroundColor(Color.badgeTextGray)
                            .background(RoundedRectangle(cornerRadius: 6).fill(Color.badgeBackgroundGray))
                        Spacer()
                    }
                    .foregroundColor(.gray)
                })
               
                

            }
//            .listStyle(.grouped)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(
                top: 0,
                leading: 20,
                bottom: 0,
                trailing: 0)
            )
            .navigationBarTitle("Home", displayMode: .large)
            .accentColor(.mainYellow)
        }
        
    }
    
    func secToHM(_ seconds: Int) -> String {
        let hr = seconds / 3600
        if hr > 0 {
            return String(format: "%02dH %02dM %02dS", seconds / 3600, seconds % 3600 / 60, ((seconds % 3600) % 60))
        }
        else {
            return String(format: "%02dM %02dS", seconds % 3600 / 60, ((seconds % 3600) % 60))
        }
    }
    
    func getTotalTime() -> String {
        var sum = 0
        self.weekReviews.forEach({
            sum += $0.totalLength
        })
        self.dayReviews.forEach({
            sum += $0.totalLength
        })
        self.hourReviews.forEach({
            sum += $0.totalLength
        })
        print(sum)
        return secToHM(sum)
    }
    
    func getPercentage() -> Double {
        var sum = 0
        self.weekReviews.forEach({
            sum += $0.totalLength
        })
        self.dayReviews.forEach({
            sum += $0.totalLength
        })
        self.hourReviews.forEach({
            sum += $0.totalLength
        })
        var sum2 = 0
        self.weekReviews.forEach({
            sum2 += Int(round(Double($0.totalLength) * $0.percent))
        })
        self.dayReviews.forEach({
            sum2 += Int(round(Double($0.totalLength) * $0.percent))
        })
        self.hourReviews.forEach({
            sum2 += Int(round(Double($0.totalLength) * $0.percent))
        })
        return (Double(sum2)/Double(sum))*100.0
    }
    
    func getPlayTime() -> String {
        var sum = 0
        self.weekReviews.forEach({
            sum += Int(round(Double($0.totalLength) * $0.percent))
        })
        self.dayReviews.forEach({
            sum += Int(round(Double($0.totalLength) * $0.percent))
        })
        self.hourReviews.forEach({
            sum += Int(round(Double($0.totalLength) * $0.percent))
        })
        return secToHM(sum)
    }

    
    

}

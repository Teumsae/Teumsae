//
//  SettingsView.swift
//  teumsae
//
//  Created by Subeen Park on 2021/12/14.
//

import SwiftUI
import RealmSwift

struct SettingsView: View {
    
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
                
                // LOCATION BASED
                if let locationGroup = locationGroups.first {
                    LocationNotificationView(group: locationGroup)
                } else {
                    ProgressView().onAppear {
                        $locationGroups.append(LocationNotificationGroup())
                    }
                }
                
                if let timeGroup = timeGroups.first {
                    TimeNotificationView(group: timeGroup)
                } else {
                    ProgressView().onAppear {
                        $timeGroups.append(TimeNotificationGroup())
                    }
                }
                
                if let tagGroup = tagGroups.first {
                    TagNotificationView(group: tagGroup)
                } else {
                    ProgressView().onAppear {
                        $tagGroups.append(TagNotificationGroup())
                    }
                }
                
                Spacer()
                

            }
//            .listStyle(.grouped)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(
                top: 0,
                leading: 20,
                bottom: 0,
                trailing: 0)
            )
            .navigationBarTitle("Notifications", displayMode: .large)
            .navigationBarItems(trailing: NavigationLink(destination: CreateNotificationView(), label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                    .foregroundColor(.mainYellow)
            }))
            .accentColor(.mainYellow)
        }
        
    }
}


struct LocationNotificationView: View {
    
    @ObservedRealmObject var group: LocationNotificationGroup
    
    var body: some View {
            Section(content: {
                ForEach(group.notifications) { item in
                    HStack {
                        Text("hello")
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                }
                .onDelete(perform: $group.notifications.remove)
                .onMove(perform: $group.notifications.move)
            }, header: {
                HStack{
                    Text("Location-based")
                        .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 20))
                    Text("\(group.notifications.count)")
                        .font(Font.custom("AppleSDGothicNeo-Bold", fixedSize: 14))
                        .padding([.leading, .trailing], 6)
                        .padding([.top, .bottom], 3)
                        .foregroundColor(Color.badgeTextGray)
                        .background(RoundedRectangle(cornerRadius: 6).fill(Color.badgeBackgroundGray))
                    Spacer()
                }
                .foregroundColor(.gray)
            })
//        .listRowSeparatorTint(Color.white)
        
    }
    
}


struct TimeNotificationView: View {
    
    @ObservedRealmObject var group: TimeNotificationGroup
    
    var body: some View {
        Section(content: {
            ForEach(group.notifications) { item in
                TimeNotificationRow(item: item)
                .listRowSeparator(.hidden)
            }
            .onDelete(perform: $group.notifications.remove)
            .onMove(perform: $group.notifications.move)
        }, header: {
            HStack{
                Text("Time-based")
                    .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 20))
                Text("\(group.notifications.count)")
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
    
}


struct TimeNotificationRow: View {
    @ObservedRealmObject var item: TimeNotification
    var body: some View {
        // You can click an item in the list to navigate to an edit details screen.
        Toggle(isOn: $item.isTurnedOn) {
            Text(item.title)
                .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 18))
        }
        .tint(.orange)
    }
}

struct TagNotificationView: View {
    
    @ObservedRealmObject var group: TagNotificationGroup
    
    var body: some View {
        Section(content: {
            ForEach(group.notifications) { item in
                TagNotificationRow(item: item)
                .listRowSeparator(.hidden)
            }
            .onDelete(perform: $group.notifications.remove)
            .onMove(perform: $group.notifications.move)
        }, header: {
            HStack{
                Text("Tag-based")
                    .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 20))
                Text("\(group.notifications.count)")
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
    
}


struct TagNotificationRow: View {
    @ObservedRealmObject var item: TagNotification
    var body: some View {
        // You can click an item in the list to navigate to an edit details screen.
        Toggle(isOn: $item.isTurnedOn) {
            Text(item.title)
                .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 18))
        }
        .tint(.orange)
        
    }
}






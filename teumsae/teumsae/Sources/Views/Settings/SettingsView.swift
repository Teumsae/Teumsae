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
            VStack{
                
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

                

            }
            .navigationBarTitle("Notifications", displayMode: .large)
            .navigationBarItems(trailing: NavigationLink(destination: CreateNotificationView(), label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.mainYellow)
            }))
            .accentColor(.mainYellow)
        }
        
    }
}


struct LocationNotificationView: View {
    
    @ObservedRealmObject var group: LocationNotificationGroup
    
    var body: some View {
        List {
            Section(content: {
                ForEach(group.notifications) { item in
//                    ItemRow(item: item)
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
                        .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 18))
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
//        .listRowSeparatorTint(Color.white)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0)
        )
        
    }
    
}


struct TimeNotificationView: View {
    
    @ObservedRealmObject var group: TimeNotificationGroup
    
    var body: some View {
        List {
            Section(content: {
                ForEach(group.notifications) { item in
//                    ItemRow(item: item)
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
                    Text("Time-based")
                        .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 18))
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
//        .listRowSeparatorTint(Color.white)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0)
        )
        
    }
    
}

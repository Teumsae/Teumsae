//
//  SettingsViewKeep.swift
//  teumsae
//
//  Created by Subeen Park on 2021/12/14.
//

import SwiftUI
import RealmSwift

struct SettingsViewKeep: View {
    
    @ObservedResults(LocationNotificationGroup.self) var groups
    
    init() {
//        UINavigationBar.appearance().barTintColor = UIColor(Color.mainYellow)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.mainYellow)]
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font : UIFont(name: "AppleSDGothicNeo-Bold", size: 20)!,
            .foregroundColor: UIColor(Color.mainYellow)]
    }
    
    var body: some View {
            if let group = groups.first {
                // Pass the Group objects to a view further
                // down the hierarchy
                notificationsView(group: group)
            } else {
                // For this small app, we only want one group in the realm.
                // You can expand this app to support multiple groups.
                // For now, if there is no group, add one here.
                ProgressView().onAppear {
                    $groups.append(LocationNotificationGroup())
                }
            }
        }
}



struct notificationsView: View {
    /// The group is a container for a list of notifications. Using a group instead of all notifications
    /// directly allows us to maintain a list order that can be updated in the UI.
    @ObservedRealmObject var group: LocationNotificationGroup
    /// The button to be displayed on the top left.
    var leadingBarButton: AnyView?
    var body: some View {
        NavigationView {
            VStack {
                // The list shows the notifications in the realm.
                
                
                List {
                    ForEach(group.notifications) { item in
                        ItemRow(item: item)
                    }.onDelete(perform: $group.notifications.remove)
                    .onMove(perform: $group.notifications.move)
                }.listStyle(GroupedListStyle())
                    .navigationBarTitle("notifications", displayMode: .large)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(
                        leading: self.leadingBarButton,
                        // Edit button on the right to enable rearranging notifications
                        trailing: EditButton())
                

//                List {
//                    Section(header: Text("Location based")) {
//                        ForEach(group.notifications) { item in
//                            ItemRow(item: item)
//                        }
//                        .onDelete(perform: $group.notifications.remove)
//                        .onMove(perform: $group.notifications.move)
//
//                    }
//
//                    Section(header: Text("Location based")) {
//                        ForEach(group.notifications) { item in
//                            ItemRow(item: item)
//                        }
//                        .onDelete(perform: $group.notifications.remove)
//                        .onMove(perform: $group.notifications.move)
//                    }
//                }
//
                
                
                // Action bar at bottom contains Add button.
                HStack {
                    Spacer()
                    Button(action: {
                        // The bound collection automatically
                        // handles write transactions, so we can
                        // append directly to it.
                        $group.notifications.append(LocationNotification())
                    }) { Image(systemName: "plus") }
                }.padding()
            }
        }
    }
}


struct ItemRow: View {
    @ObservedRealmObject var item: LocationNotification
    var body: some View {
        // You can click an item in the list to navigate to an edit details screen.
        NavigationLink(destination: ItemDetailsView(item: item)) {
            Text(item.title)
            if item.isTurnedOn {
                // If the user "favorited" the item, display a heart icon
                Image(systemName: "heart.fill")
            }
        }
    }
}
/// Represents a screen where you can edit the item's name.
struct ItemDetailsView: View {
    
    @ObservedRealmObject var item: LocationNotification
    var body: some View {
        VStack(alignment: .leading) {
            Text("Enter a new name:")
            // Accept a new name
            TextField("New name", text: $item.title)
                .navigationBarTitle(item.title)
                .navigationBarItems(trailing: Toggle(isOn: $item.isTurnedOn) {
                    Image(systemName: item.isTurnedOn ? "heart.fill" : "heart")
                })
        }.padding()
    }
    
}

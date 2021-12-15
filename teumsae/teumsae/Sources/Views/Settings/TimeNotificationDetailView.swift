//
//  TimeNotificationDetailView.swift
//  teumsae
//
//  Created by subeen on 2021/12/15.
//

import SwiftUI
import RealmSwift

struct TimeNotificationDetailView: View {
    
    init(notification: TimeNotification) {
        self.notification = notification
        UINavigationBar.appearance().tintColor = UIColor(Color.mainYellow)
    }
    
    @State var editMode: EditMode = .inactive
    @Environment(\.presentationMode) var presentationMode
    @ObservedRealmObject var notification: TimeNotification

    @State private var title: String = ""
    @State private var currentDate = Date()
    private var days = ["S", "M", "T", "W", "T", "F", "S", ]
    @State private var daysSelected: [Int] = []
        
    var body: some View {
        
        VStack {
            GroupBox(
                   label: Label("TITLE", systemImage: "tag.fill")
                       .foregroundColor(.mainYellow)
               ) {
                   TextField("", text: $title)
                       .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 24))
                       .foregroundColor(.subBlack)
                       .disabled(editMode == .inactive)
            }
            
            GroupBox(
                   label: Label("TIME TABLE", systemImage: "calendar.badge.clock")
                       .foregroundColor(.mainYellow)
               ) {
                   HStack {
                       DatePicker("", selection: $currentDate, displayedComponents: .hourAndMinute)
                           .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 17))
                           .labelsHidden()
                           .pickerStyle(.wheel)
                       ForEach(Array(days.enumerated()), id: \.offset) { idx, day in
                           
                           Button(action: {
                               if daysSelected.contains(idx+1) {
                                   daysSelected = daysSelected.filter({$0 != idx+1})
                               } else {
                                   daysSelected.append(idx+1)
                               }
                           }, label: {
                               Text(day)
                                   .frame(maxWidth: .infinity)
                                   .font(Font.custom("AppleSDGothicNeo-Bold", fixedSize: 15))
                                   .padding([.leading, .trailing], 3)
                                   .padding([.top, .bottom], 2)
                                   .foregroundColor(daysSelected.contains(idx+1) ? Color.white: Color.mainYellow)
                                   .background(RoundedRectangle(cornerRadius: 6).fill(daysSelected.contains(idx+1) ? Color.mainYellow: Color.clear))
                           })
                               .disabled(editMode == .inactive)
                       }

                       
                   }
                   
            }
            Spacer()
        }
        .navigationBarTitle("Notifications")
        .onAppear {
            let myDateComponents = DateComponents(hour: notification.hr ?? 0, minute: notification.min ?? 0)
            let calendar = Calendar.current
            let myDate = calendar.date(from: myDateComponents) // "Feb 22, 2222 at 12:00 AM"
            currentDate = myDate!
            title = notification.title
            daysSelected = notification.days.map {
                $0
            }
        }

        .navigationBarItems(trailing: Button(action: {
            
            editMode = editMode == .active ? .inactive : .active
            
            if editMode == .inactive {
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: currentDate)
                let minute = calendar.component(.minute, from: currentDate)
                
                 
                
                let realm = try! Realm()
                
                try! realm.write {
                    
                    notification.thaw()?.title = title
                    notification.thaw()?.hr = hour
                    notification.thaw()?.min = minute
                    notification.thaw()?.days.removeAll()
                    daysSelected.forEach {
                        notification.thaw()?.days.append($0)
                    }
                    
                }
            }
            
        }, label: {
            Text(editMode == .active ? "Done" : "Edit")
        }))
        .padding()
    }
}



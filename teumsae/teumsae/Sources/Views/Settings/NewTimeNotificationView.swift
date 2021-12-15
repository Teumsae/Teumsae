//
//  NewTimeNotificationView.swift
//  teumsae
//
//  Created by Subeen Park on 2021/12/14.
//

import SwiftUI
import RealmSwift

struct NewTimeNotificationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedResults(TimeNotificationGroup.self) var timeGroups

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
                   TextField("알림 \(timeGroups.first!.notifications.count + 1)", text: $title)
                       .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 24))
                       .foregroundColor(.subBlack)
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
                       }

                   }
            }
        }

        .navigationBarItems(trailing: Button(action: {
            
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: currentDate)
            let minute = calendar.component(.minute, from: currentDate)
            
            let realm = try! Realm()
            
            let title = title.isEmpty ? "알림 \(timeGroups.first!.notifications.count + 1)" : title
            print("TITLE \(title)")
            print("IS TITLE EMPTY \(title.isEmpty)")

            try! realm.write {
                guard let timeGroups = timeGroups.thaw() else { return }
                if let timeGroup = timeGroups.first {
                    timeGroup.notifications.append(TimeNotification(title: title.isEmpty ? "알림 \(timeGroups.first!.notifications.count + 1)" : title, hr: hour, min: minute, days: daysSelected))
                    print(timeGroup.notifications.last)
                }
            }
            
            presentationMode.wrappedValue.dismiss()

            
            
            

            
        }, label: {
            Text("Done")
        }))
    }
}


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

    @State private var title = ""
    @State private var currentDate = Date()
    private var days = ["M", "T", "W", "T", "F", "S", "S"]
    @State private var daysSelected: [Int] = []
        
    var body: some View {
        VStack(spacing: 20) {
            TextField("알림 \(timeGroups.first!.notifications.count + 1)", text: $title)
                .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 24))
                .foregroundColor(.subBlack)
            HStack {
                DatePicker("", selection: $currentDate, displayedComponents: .hourAndMinute)
                    .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 17))
                    .labelsHidden()
                    .pickerStyle(.wheel)
                ForEach(Array(days.enumerated()), id: \.offset) { idx, day in
                    
                    Button(action: {
                        if daysSelected.contains(idx) {
                            daysSelected = daysSelected.filter({$0 != idx})
                        } else {
                            daysSelected.append(idx)
                            
                        }
                    }, label: {
                        Text(day)
                            .frame(maxWidth: .infinity)
                            .font(Font.custom("AppleSDGothicNeo-Bold", fixedSize: 15))
                            .padding([.leading, .trailing], 3)
                            .padding([.top, .bottom], 2)
                            .foregroundColor(Color.badgeTextGray)
                            .background(RoundedRectangle(cornerRadius: 6).fill(daysSelected.contains(idx) ? Color.badgeBackgroundGray : Color.white))
                    })
                }

            }
            Spacer()
        }
        .padding()
        .navigationBarItems(trailing: Button(action: {
            
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: currentDate)
            let minute = calendar.component(.minute, from: currentDate)
            
            
            presentationMode.wrappedValue.dismiss()
            
//            guard let realm = thawed.realm() else {
//                return
//            }
//
//            try! realm.write {
//                if let timeGroup = timeGroups.first {
//                    timeGroup.notifications.append(TimeNotification(title: title.isEmpty ? "알림 \(timeGroup.notifications.count + 1)" : title, hr: hour, min: minute, days: daysSelected))
//                }
//            }

            
        }, label: {
            Text("Done")
        }))
    }
}


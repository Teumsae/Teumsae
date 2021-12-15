//
//  NewTagNotificationView.swift
//  teumsae
//
//  Created by Subeen Park on 2021/12/14.
//

import SwiftUI
import RealmSwift

struct NewTagNotificationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedResults(TagNotificationGroup.self) var tagGroups
    @State private var editMode = EditMode.active

    @State private var title: String = ""
    @State private var currentDate = Date()
    private var days = [ "S", "M", "T", "W", "T", "F", "S"]
    @State private var daysSelected: [Int] = []
    @State private var timeStamps: [DateComponents] = []
        
    var body: some View {
        VStack(spacing: 10) {
            
            GroupBox(
                   label: Label("TAG", systemImage: "tag.fill")
                       .foregroundColor(.mainYellow)
               ) {
                   TextField("과목 \(tagGroups.first!.notifications.count + 1)", text: $title)
                       .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 24))
                       .foregroundColor(.subBlack)
            }
            
            GroupBox(
                   label: Label("TIME TABLE", systemImage: "calendar.badge.clock")
                       .foregroundColor(.mainYellow)
               ) {
                   HStack {
                       Button(action: {
                           let calendar = Calendar.current
                           let hour = calendar.component(.hour, from: currentDate)
                           let minute = calendar.component(.minute, from: currentDate)
                           
                           daysSelected.map ({
                               timeStamps.append(DateComponents(hour: hour, minute: minute, weekday: $0))
                           })
                           daysSelected = []
                           
                       }, label: {
                           Image(systemName: "plus.app.fill")
                               .resizable()
                               .frame(width: 30, height: 30, alignment: .center)
                               .foregroundColor(Color.unselectedGray)
                       })
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
            
            List {
                // CURRENT TIMESTAMPS
                ForEach($timeStamps, id: \.self) { $item in
                    HStack {
                        Text("\(getTodayWeekDay(components: item))")
                            .font(Font.custom("AppleSDGothicNeo-Light", fixedSize: 18))
                            .foregroundColor(.badgeTextGray)
                        Spacer()
                    }
                }
                .onMove { indexSet, offset in
                    timeStamps.move(fromOffsets: indexSet, toOffset: offset)
                }
                .onDelete { indexSet in
                    timeStamps.remove(atOffsets: indexSet)
                }
            }
            .listStyle(.plain)

            Spacer()
        }
        .navigationBarItems(trailing: Button(action: {

            let calendar = Calendar.current
            
            let hour = calendar.component(.hour, from: currentDate)
            let minute = calendar.component(.minute, from: currentDate)

            let realm = try! Realm()

            try! realm.write {
                guard let tagGroups = tagGroups.thaw() else { return }
                
                print(timeStamps)
                if let tagGroup = tagGroups.first {
                    tagGroup.notifications.append(TagNotification(title: title.isEmpty ? "과목 \(tagGroups.first!.notifications.count + 1)" : title, timeStamps: timeStamps))
                }
            }

            presentationMode.wrappedValue.dismiss()

            
        }, label: {
            Text("Done")
        }))
    }
    
    func getTodayWeekDay(components: DateComponents)-> String{
        
        let calendar = Calendar.current
        let date = calendar.date(from: components)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh : mm a · EEE"
        let weekDay = dateFormatter.string(from: date!)
        return weekDay
     }
}

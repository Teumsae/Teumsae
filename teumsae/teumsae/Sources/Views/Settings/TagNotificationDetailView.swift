//
//  TagNotificationDetailView.swift
//  teumsae
//
//  Created by subeen on 2021/12/15.
//

import SwiftUI
import RealmSwift

public struct TagNotificationDetailView: View {
    
    init(notification: TagNotification) {
        self.notification = notification
        UINavigationBar.appearance().tintColor = UIColor(Color.mainYellow)
    }
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedRealmObject var notification : TagNotification
    @State var editMode: EditMode = .inactive
    @State private var title: String = ""
    @State private var currentDate = Date()
    private var days = [ "S", "M", "T", "W", "T", "F", "S"]
    @State private var daysSelected: [Int] = []
    @State private var timeStamps: [DateComponents] = []
        
    public var body: some View {
        VStack(spacing: 10) {
            
            GroupBox(
                   label: Label("TAG", systemImage: "tag.fill")
                       .foregroundColor(.mainYellow)
               ) {
                   TextField("", text: $title)
                       .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 24))
                       .foregroundColor(.subBlack)
                       .disabled(true)
                   
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
                               print("DATE \(DateComponents(hour: hour, minute: minute, weekday: $0))")
                           })
                           daysSelected = []
                           
                       }, label: {
                           Image(systemName: "plus.app.fill")
                               .resizable()
                               .frame(width: 30, height: 30, alignment: .center)
                               .foregroundColor(Color.unselectedGray)
                       })
                           .disabled(editMode == .inactive)
                       DatePicker("", selection: $currentDate, displayedComponents: .hourAndMinute)
                           .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 17))
                           .labelsHidden()
                           .pickerStyle(.wheel)
                           .disabled(editMode == .inactive)
                      
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
            
            List {
                // CURRENT TIMESTAMPS
                ForEach(timeStamps, id: \.self) { item in
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
            .environment(\.editMode, $editMode)
            Spacer()
        }
        .padding()
        .onAppear(perform: {
            title = notification.title
            timeStamps = notification.timeStamps
            daysSelected = []
        })
        .navigationBarTitle("Notifications")
        .navigationBarItems(trailing: Button(action: {
            
            editMode = editMode == .active ? .inactive : .active
            
            if editMode == .inactive {
                let calendar = Calendar.current
                
                let hour = calendar.component(.hour, from: currentDate)
                let minute = calendar.component(.minute, from: currentDate)

                let realm = try! Realm()

                try! realm.write {
                    
                    notification.thaw()?.title = title
                    notification.thaw()?.timeTables.removeAll()
                    timeStamps.map {
                        notification.thaw()?.timeTables.append(TimeTable(date: $0))
                    }
                    
                }
            }



            
        }, label: {
            editMode == .inactive ? Text("Edit") : Text("Done")
        }))
        
    }
    
    func getTodayWeekDay(components: DateComponents)-> String{
        
        let dayDict = [
            1: "SUN",
            2: "MON",
            3: "TUE",
            4: "WED",
            5: "THU",
            6: "FRI",
            7: "SAT"
        ]
        
        print("COMPONENTS \(components)")
        let calendar = Calendar.current
        let date = calendar.date(from: components)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh : mm a · "
        let weekDay = dateFormatter.string(from: date!)
        
        return weekDay+dayDict[components.weekday!]!
     }
}



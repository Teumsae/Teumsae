//
//  CreateNotificationView.swift
//  teumsae
//
//  Created by Subeen Park on 2021/12/14.
//

import SwiftUI
import RealmSwift

struct CreateNotificationView: View {

    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.mainYellow)
//        UISegmentedControl.appearance().backgroundColor = UIColor(Color.subYellow)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor:UIColor(Color.mainYellow)], for: .normal)
    }
    
    @State private var notificationType = 0
    
    var body: some View {
        VStack {
            Picker("What is your favorite color?", selection: $notificationType) {
                Text("LOCATION")
                    .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 14))
                    .tag(0)
                Text("TIME")
                    .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 14))
                    .tag(1)
                Text("TAG")
                    .font(Font.custom("AppleSDGothicNeo-SemiBold", fixedSize: 14))
                    .tag(2)
            }
            .pickerStyle(.segmented)
            switch notificationType {
            case 0:
                NewLocationNotificationView()
                    .padding(.top, 10)
            case 1:
                NewTimeNotificationView()
                    .padding(.top, 10)
            default:
                NewTagNotificationView()
                    .padding(.top, 10)
                
            }
            Spacer()
        }
        .navigationBarTitle("", displayMode: .inline)
        .padding([.leading, .trailing], 10)
        
        

    }
}




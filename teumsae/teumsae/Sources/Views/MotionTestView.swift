//
//  MotionTestView.swift
//  teumsae
//
//  Created by seungyeon on 2021/11/28.
//
//  ref: https://stackoverflow.com/questions/62020407/swiftui-and-core-motion
import SwiftUI
import CoreMotion
import Foundation


struct MotionTestView: View {
    
//    @ObservedObject
//    var motion: MotionManager
    
    let motionManager = CMMotionActivityManager()
    let queue = OperationQueue()
    
    @State private var activity = "stationary" // treat all unknowns as stationary
    
    var body: some View {
        VStack{
            Text("Home")
            Text("Motion Test")
            Text("Activity: \(activity)")
            
        }//Vstak
            .onAppear {
                print("ON APPEAR")
                        
//                self.motionManager.startActivityUpdates(to: OperationQueue.current!, withHandler: {
                self.motionManager.startActivityUpdates(to: self.queue, withHandler: {
                (deviceActivity: CMMotionActivity!) -> Void in
                    
                    if deviceActivity.stationary {
                        print("Motion: stationary")
                        DispatchQueue.main.async {
                            self.activity = "stationary"
                        }
                    }
                    else if deviceActivity.walking {
                        print("Motion: walking")
                        DispatchQueue.main.async {
                            self.activity = "walking"
                        }
                    }
                    else if deviceActivity.running{
                        print("Motion: running")
                        DispatchQueue.main.async {
                            self.activity = "running"
                        }
                    }
                    else if deviceActivity.automotive{
                        print("Motion: automotive")
                        DispatchQueue.main.async {
                            self.activity = "automotive"
                        }
                    }
                    else {
                        print("Motion: unknown")
                        DispatchQueue.main.async {
                            self.activity = "stationary"
                        }
                    }
            })
        } //.onappear
    }
}

struct MotionTestView_Previews: PreviewProvider {
    static var previews: some View {
        MotionTestView()
    }
}

//
//  MyDeviceActivityManager.swift
//  teumsae
//
//  Created by woogie on 2021/12/13.
//

//  MyDeviceActivityMonitor




import Foundation
import DeviceActivity
import ManagedSettings



@available(iOS 15.0, *)
class MyDeviceActivityMonitor: DeviceActivityMonitor{
	let store = ManagedSettingsStore()
	
	

	override func intervalDidStart(for activity: DeviceActivityName) {

		super.intervalDidStart(for: activity)
		
		
	}

	

	override func intervalDidEnd(for activity: DeviceActivityName) {

		super.intervalDidEnd(for: activity)

	}

	

	override func eventDidReachThreshold(_ event:DeviceActivityEvent.Name,activity:DeviceActivityName){

		

		super.eventDidReachThreshold(event, activity: activity)

	}

	

}

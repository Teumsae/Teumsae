//
//  CoreMotion.swift
//  teumsae
//
//  Created by woogie on 2021/11/28.
//
// ref: https://medium.com/@tyler.hutcherson/activity-classification-with-create-ml-coreml3-and-skafos-part-2-734f1ea2f6e
// https://apple.github.io/turicreate/docs/userguide/activity_classifier/export_coreml.html
import Foundation
import CoreML
import CoreMotion
// Define some ML Model constants for the recurrent network
struct ModelConstants {
	static let numOfFeatures = 6
	// Must be the same value you used while training
	static let predictionWindowSize = 30
	// Must be the same value you used while training
	static let sensorsUpdateFrequency = 1.0 / 10.0
	static let hiddenInLength = 20
	static let hiddenCellInLength = 200
}

class ActivityManager {
	
	static let shared = ActivityManager()
	// create only one motionManager
	static let motionManager = CMMotionManager()
	
	
	// Initialize the model, layers, and sensor data arrays
	private let classifier = try! TeumsaeActivityClassifier1(configuration: .init())
	var currentIndexInPredictionWindow = 0
	
	let accX = try? MLMultiArray(
		shape: [ModelConstants.predictionWindowSize] as [NSNumber],
		dataType: MLMultiArrayDataType.double)
	let accY = try? MLMultiArray(
		shape: [ModelConstants.predictionWindowSize] as [NSNumber],
		dataType: MLMultiArrayDataType.double)
	let accZ = try? MLMultiArray(
		shape: [ModelConstants.predictionWindowSize] as [NSNumber],
		dataType: MLMultiArrayDataType.double)
	let rotX = try? MLMultiArray(
		shape: [ModelConstants.predictionWindowSize] as [NSNumber],
		dataType: MLMultiArrayDataType.double)
	let rotY = try? MLMultiArray(
		shape: [ModelConstants.predictionWindowSize] as [NSNumber],
		dataType: MLMultiArrayDataType.double)
	let rotZ = try? MLMultiArray(
		shape: [ModelConstants.predictionWindowSize] as [NSNumber],
		dataType: MLMultiArrayDataType.double)
	var currentState = try? MLMultiArray(
		shape: [(ModelConstants.hiddenInLength +
				 ModelConstants.hiddenCellInLength) as NSNumber],
		dataType: MLMultiArrayDataType.double)
	
	// Initialize CoreMotion Manager
	
	func startDeviceMotion() {
		guard ActivityManager.motionManager.isDeviceMotionAvailable else {
			debugPrint("Core Motion Data Unavailable!")
			return
		}
		//		ActivityManager.motionManager.accelerometerUpdateInterval = TimeInterval(ModelConstants.sensorsUpdateFrequency)
		//		ActivityManager.motionManager.gyroUpdateInterval = TimeInterval(ModelConstants.sensorsUpdateFrequency)
		ActivityManager.motionManager.deviceMotionUpdateInterval = TimeInterval(ModelConstants.sensorsUpdateFrequency)
		
		ActivityManager.motionManager.startDeviceMotionUpdates(to: .main) {
			(data: CMDeviceMotion?, error: Error?) in
			guard let data = data else {return}
			self.addMotionDataSampleToArray(motionSample: data)
		}
	}
	
	func stopDeviceMotion() {
		guard ActivityManager.motionManager.isDeviceMotionAvailable else {
			debugPrint("Core Motion Data Unavailable!")
			return
		}
		// Stop streaming device data
		ActivityManager.motionManager.stopDeviceMotionUpdates()
		// Reset some parameters
		currentIndexInPredictionWindow = 0
		currentState = try? MLMultiArray(
			shape: [(ModelConstants.hiddenInLength +
					 ModelConstants.hiddenCellInLength) as NSNumber],
			dataType: MLMultiArrayDataType.double)
	}
	
	func addMotionDataSampleToArray(motionSample: CMDeviceMotion) {
		// Using global queue for building prediction array
		DispatchQueue.global().async {
			self.rotX![self.currentIndexInPredictionWindow] = motionSample.rotationRate.x as NSNumber
			self.rotY![self.currentIndexInPredictionWindow] = motionSample.rotationRate.y as NSNumber
			self.rotZ![self.currentIndexInPredictionWindow] = motionSample.rotationRate.z as NSNumber
			self.accX![self.currentIndexInPredictionWindow] = motionSample.userAcceleration.x as NSNumber
			self.accY![self.currentIndexInPredictionWindow] = motionSample.userAcceleration.y as NSNumber
			self.accZ![self.currentIndexInPredictionWindow] = motionSample.userAcceleration.z as NSNumber
			
			// Update prediction array index
			self.currentIndexInPredictionWindow += 1
			
			// If data array is full - execute a prediction
			if (self.currentIndexInPredictionWindow == ModelConstants.predictionWindowSize) {
				// Move to main thread to update the UI
				DispatchQueue.main.async {
					// Use the predicted activity
					self.label.text = self.activityPrediction() ?? "N/A"
				}
				// Start a new prediction window from scratch
				self.currentIndexInPredictionWindow = 0
			}
		}
	}
	func activityPrediction() -> String? {
		// Perform prediction
		let modelPrediction = try? classifier.prediction(
			acceleration_x: accX!,
			acceleration_y: accY!,
			acceleration_z: accZ!,
			rotation_x: rotX!,
			rotation_y: rotY!,
			rotation_z: rotZ!,
			stateIn: currentState)
		// Update the state vector
		currentState = modelPrediction?.stateOut
		// Return the predicted activity
		return modelPrediction?.activity
	}
}

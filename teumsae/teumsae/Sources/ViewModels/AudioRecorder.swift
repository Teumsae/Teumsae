//
//  AudioRecorder.swift
//  teumsae
//
//  Created by Subeen Park on 2021/11/03.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation
import RealmSwift


class AudioRecorder: NSObject, ObservableObject {
	
	static let shared = AudioRecorder()
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    var audioRecorder: AVAudioRecorder!
    
    // REALM
    var recordings = [Recording]()
    @ObservedResults(Review.self) var reviews
    
    var recording = false {
            didSet {
                objectWillChange.send(self)
            }
        }
    
    var lastRecoreding: Recording? {
        return recordings.last
    }
    
    var audioConverter: AudioConverter
    override init() {
        audioConverter = AudioConverter()
        super.init()
        fetchRecordings()
    }
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        
        let timeStamp = Date()
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let relFilePath = "\(timeStamp.toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).wav"
        let audioFilename = documentPath.appendingPathComponent(relFilePath)
        
        
        let settings = [
                    AVFormatIDKey: Int(kAudioFormatLinearPCM),
//                    AVSampleRateKey: 12000,
					AVSampleRateKey: 16000,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
        
        print("AUDIO FILE NAME \(audioFilename)")
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            recording = true
            
            // REALM
            $reviews.append(Review(audioFileName: relFilePath, createdAt: timeStamp))
        } catch {
            print("Could not start recording")
        }
        
    }
    
    func stopRecording() {
        audioRecorder.stop()
        recording = false
        
        guard let audioFileURL = reviews.last?.fileURL else {
            return
        }
        
        let audioAsset = AVURLAsset.init(url: audioFileURL, options: nil)
        let duration = audioAsset.duration
        let durationInSeconds = CMTimeGetSeconds(duration)
        

        let realm = try! Realm()
        // Persist your data easily
        try! realm.write {
            reviews.last?.totalLength = Int(durationInSeconds)
        }
        
//        let realm: Realm = try! Realm()
//        if let audioFileURL = recordings.last?.fileURL {
//
//
//        } else {
//            try! realm.write {
//                reviews.last?.totalLength = 1
//            }
//        }
//
        
        
        audioConverter.convertToText(fileURL: (reviews.last?.fileURL) as! URL)
        
        print("\(PersistenceManager.shared.read())") 
    }
    
    func fetchRecordings() {
        recordings.removeAll()
        recordings = PersistenceManager.shared.read()
        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
        objectWillChange.send(self)
    }
    
    func deleteRecording(urlsToDelete: [String]){
        for url in urlsToDelete{
            print(url)
            do{
//                try FileManager.default.removeItem(at: url)
                PersistenceManager.shared.deleteByFileURL(audioFileName: url)
            } catch{
                print("File could not be deleted!")
            }
        }
        
        fetchRecordings()
    }
    
    
    
}

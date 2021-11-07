//
//  AudioConverter.swift
//  teumsae
//
//  Created by seungyeon on 2021/11/05.
//

import Foundation
import Alamofire
import AVFAudio
import SwiftUI

struct DecodableType: Decodable {
    var type: String
    var value: String
    var nBest: [nBestStruct]
    var voiceProfile: voieceProfileStruct
    var durationMS: Int
    var qmarkScore: Int
    var gender: Int
}

struct nBestStruct: Decodable {
    var value: String
    var score : Int
}

struct voieceProfileStruct: Decodable {
    var registered: Bool
    var authenticated : Bool
}




class AudioConverter: NSObject, ObservableObject {
 
    override init() {
        super.init()
    }

    
    func getBestText(text: String) -> String {
        var textArr = text.components(separatedBy: "\r\n")
        textArr.removeLast()
        textArr.removeLast()
        var finalVal = textArr.last!.components(separatedBy: ",")[1]
        let start = finalVal.index(finalVal.startIndex, offsetBy: 9)
        let end = finalVal.index(finalVal.endIndex, offsetBy: -1)
//        print(String(finalVal[start..<end]))
        return String(finalVal[start..<end])
    }

    
    func convertToText(fileURL: URL){
        // getting fileName
        let urlStr = "\(fileURL)"
        let pathArr = urlStr.components(separatedBy: "/")
        let fileName = String(pathArr.last!)
        print("Here is the fileName: \(fileName)")
        
        let headers : HTTPHeaders = ["Transfer-Encoding": "chunked", "Content-Type": "application/octet-stream", "Authorization": "e168cb15198d17108619e66fb061dc92"]

        
        do {
            let audioData = try Data(contentsOf: fileURL)
            //let audioData = try AVAudioFile(forReading: fileURL)
            AF.upload(multipartFormData: { multipartFormData in
                     multipartFormData.append(audioData, withName: fileName)
            }, to: "https://kakaoi-newtone-openapi.kakao.com/v1/recognize", headers: headers)
                    .responseString {
                        response in
//                        print(String(data: response.data!, encoding: .utf8))
                        let text = String(data: response.data!, encoding: .utf8)
                        let finalText = self.getBestText(text: text ?? "empty")
                        
                        PersistenceManager.shared.updateByFileURL(fileURL: fileURL, recording: Recording(fileURL: fileURL, createdAt: fileURL.getCreationDate(), transcription: finalText))
                        
                        let updatedRecordings = PersistenceManager.shared.read()
                        print("UPDATED RECORDINGS \(updatedRecordings)")
                        
                        print(finalText)
                    }
            
        } catch {
         print(" not able to upload data\(error)")
        }


    }
    
}

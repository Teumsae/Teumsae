//
//  AudioConverter.swift
//  teumsae
//
//  Created by seungyeon on 2021/11/05.
//

import Foundation
import Alamofire
import AVFAudio

class AudioConverter: NSObject, ObservableObject {
    override init() {
        super.init()
    }
    
    
    func sendAudio(fileURL: URL){
        // getting fileName
        let urlStr = "\(fileURL)"
        let pathArr = urlStr.components(separatedBy: "/")
        let fileName = String(pathArr.last!)
        print("Here is the fileName: \(fileName)")
        
        let headers : HTTPHeaders = ["Transfer-Encoding": "chunked", "Content-Type": "application/octet-stream", "Authorization": "e168cb15198d17108619e66fb061dc92"]

        do {
            let audioData = try Data(contentsOf: fileURL)
            //let audioData = try AVAudioFile(contentsOf: fileURL)
            AF.upload(multipartFormData: { multipartFormData in
                     multipartFormData.append(audioData, withName: fileName)
            }, to: "https://kakaoi-newtone-openapi.kakao.com/v1/recognize", headers: headers)
                     .responseJSON { response in
                         debugPrint(response)
                 }

        } catch {
         print(" not able to upload data\(error)")
        }

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
                     .responseString { response in
                         debugPrint(response)
                 }

        } catch {
         print(" not able to upload data\(error)")
        }
        
        
        /*
        let headers : HTTPHeaders = ["Transfer-Encoding": "chunked", "Content-Type": "application/octet-stream", "Authorization": "e168cb15198d17108619e66fb061dc92"]  //TODO: REST_API_KEY
        let kakaoURL = "https://kakaoi-newtone-openapi.kakao.com/v1/recognize"
        print(fileURL)
        //let audioData: NSData = fileURL
        let parameters: Parameters = ["-data-binary": fileURL]
        AF.request(kakaoURL, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).responseString() { response in
          switch response.result {
          case .success:
            if let data = try! response.result.get() as? [String: String] {
              print(data)
            }
          case .failure(let error):
            print("Error: \(error)")
            return
          }
        }*/
    }
    
    
}

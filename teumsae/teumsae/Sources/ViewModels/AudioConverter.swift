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
//                .responseData { dataResponse in
//
//                    switch dataResponse.result {
//                    case .success:
//                        guard let value = dataResponse.data else {return}
//
//                        print("VALUE \(value)")
//
//                        let decoder = JSONDecoder()
//                        guard let decodedData =  try? decoder.decode(STTDataModel.self, from: value)
//                        else {
//                            print("DECODING ERROR")
//                            return
//                        }
//
//                        print("DECODING RESULT[nBEST]: \(decodedData.nBest)")
//                        print("DECODING RESULT[VALUE]: \(decodedData.value)")
//
//                    case .failure:
//                        print("API ERROR \(dataResponse.error)")
//                    }
//
//                }
//                     .responseString { response in
//                         print(String(data: response.data!, encoding: .utf8))
//                 }

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

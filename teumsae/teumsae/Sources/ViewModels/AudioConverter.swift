//
//  AudioConverter.swift
//  teumsae
//
//  Created by seungyeon on 2021/11/05.
//

import Foundation
import Alamofire

class AudioConverter: NSObject, ObservableObject {

    
    func convertToText(fileURL: URL){
        let headers : HTTPHeaders = ["Transfer-Encoding": "chunked", "Content-Type": "application/octet-stream", "Authorization": "KakaoAK {REST_API_KEY}"]  //TODO: REST_API_KEY
        let kakaoURL = "https://kakaoi-newtone-openapi.kakao.com/v1/recognize"
        let parameters: Parameters = ["-data-binary": fileURL]
        AF.request(kakaoURL, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).responseJSON() { response in
          switch response.result {
          case .success:
            if let data = try! response.result.get() as? [String: Any] {
              print(data)
            }
          case .failure(let error):
            print("Error: \(error)")
            return
          }
        }
    }
    
    
}

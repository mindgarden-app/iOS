//
//  GardenService.swift
//  MindGarden
//
//  Created by Sunghee Lee on 08/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import Foundation
import Alamofire

struct GardenService {
    
    static let shared = GardenService()
    let header: HTTPHeaders = [
        "Content-Type" : "application/x-www-form-urlencoded",
    ]
    
    func getGarden(userIdx: Int, date: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let URL = APIConstants.GardenURL + "/\(userIdx)/\(date)"
        
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
            .responseData { response in
                switch response.result {
                    
                case .success:
                    if let value = response.result.value {
                        if let status = response.response?.statusCode {
                            
                            switch status {
                            case 200:
                                do {
                                    let decoder = JSONDecoder()
                                    let result = try decoder.decode(ResponseArray<Tree>.self, from: value)
                                    
                                    switch result.success {
                                    case true:
                                        completion(.success(result.data!))
                                    case false:
                                        completion(.requestErr(result.message))
                                    }
                                } catch {
                                    completion(.pathErr)
                                }
                            case 400:
                                completion(.pathErr)
                            case 500:
                                completion(.serverErr)
                                
                            default:
                                break
                            }
                        }
                    }
                    break
                
                case .failure(let err):
                    print(err.localizedDescription)
                    completion(.networkFail)
                    break
                }
            }
    }
    
    func addTree(userIdx: Int, location: Int, treeIdx: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let body: Parameters = [
            "userIdx": userIdx,
            "location": location,
            "treeIdx": treeIdx
        ]
        
        Alamofire.request(APIConstants.GardenAddURL, method: .post, parameters: body, encoding: URLEncoding.httpBody, headers: header)
            .responseData { response in
                print(response)
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        if let status = response.response?.statusCode {
                            switch status {
                            case 200:
                                do {
                                    print(APIConstants.GardenAddURL)
                                    let decoder = JSONDecoder()
                                    let result = try decoder.decode(ResponseArray<Grid>.self, from: value)
                                    
                                    switch result.success {
                                    case true:
                                        print(result.message)
                                        completion(.success(result.message))
                                    case false:
                                        completion(.requestErr(result.message))
                                    }
                                } catch {
                                    completion(.pathErr)
                                }
                            case 400:
                                completion(.pathErr)
                            case 500:
                                completion(.serverErr)
                                
                            default:
                                break
                            }
                        }
                    }
                    break
                    
                case .failure(let err):
                    print(err.localizedDescription)
                    completion(.networkFail)
                    break
                }
        }
    }
    
    func writeComment(epIdx: Int, content: String, cmtImg: UIImage, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        Alamofire.upload(
            multipartFormData: { (multipart) in
                multipart.append("\(epIdx)".data(using: .utf8)!, withName: "epIdx")
                multipart.append(content.data(using: .utf8)!, withName: "content")
                multipart.append(cmtImg.jpegData(compressionQuality: 0.5)!, withName: "cmtImg", fileName: "image.jpeg", mimeType: "image/jpeg")
        },
            to: APIConstants.GardenURL,
            method: .post,
            headers: header) { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.responseData { (response) in
                        if let value = response.result.value {
                            if let status = response.response?.statusCode {
                                
                                switch status {
                                case 200:
                                    do {
                                        let decoder = JSONDecoder()
                                        let result = try decoder.decode(DefaultRes.self, from: value)
                                        
                                        switch result.success {
                                        case true:
                                            completion(.success(result.message))
                                        case false:
                                            completion(.requestErr(result.message))
                                        }
                                    } catch {
                                        print("error")
                                    }
                                case 400:
                                    completion(.pathErr)
                                case 500:
                                    completion(.serverErr)
                                default:
                                    break
                                }
                            }
                        }
                    }
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    completion(.networkFail)
                    break
                }
                
        }
    }
}


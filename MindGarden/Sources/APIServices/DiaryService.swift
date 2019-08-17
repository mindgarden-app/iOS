//
//  DiaryService.swift
//  MindGarden
//
//  Created by Sunghee Lee on 08/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import Foundation
import Alamofire

struct DiaryService {
    
    static let shared = DiaryService()
    
    func addDiary(diaryContent: String, diaryImage: UIImage?, weatherIdx: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "token" : UserDefaults.standard.string(forKey: "token")!
        ]
        
        Alamofire.upload(
            multipartFormData: { (multipart) in
                multipart.append(diaryContent.data(using: .utf8)!, withName: "diary_content")
                if diaryImage != nil {
                    multipart.append(diaryImage!.jpegData(compressionQuality: 0.5)!, withName: "diary_img", fileName: "image.jpeg", mimeType: "image/jpeg")
                }
                multipart.append("\(weatherIdx)".data(using: .utf8)!, withName: "weatherIdx")
        },
            to: APIConstants.DiaryAddURL,
            method: .post,
            headers: headers) { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.responseData { (response) in
                        if let value = response.result.value {
                            if let status = response.response?.statusCode {
                                
                                switch status {
                                case 200:
                                    do {
                                        let decoder = JSONDecoder()
                                        let result = try decoder.decode(ResponseString.self, from: value)
                                        
                                        switch result.success {
                                        case true:
                                            print(result.message)
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
    
    func editDiary(date: String, diaryContent: String, diaryImage: UIImage?, weatherIdx: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "token" : UserDefaults.standard.string(forKey: "token")!
        ]
        
        Alamofire.upload(
            multipartFormData: { (multipart) in
                multipart.append(diaryContent.data(using: .utf8)!, withName: "diary_content")
                if diaryImage != nil {
                    multipart.append(diaryImage!.jpegData(compressionQuality: 0.5)!, withName: "diary_img", fileName: "image.jpeg", mimeType: "image/jpeg")
                }
                multipart.append("\(weatherIdx)".data(using: .utf8)!, withName: "weatherIdx")
                multipart.append(date.data(using: .utf8)!, withName: "date")
        },
            to: APIConstants.DiaryEditURL,
            method: .put,
            headers: headers) { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    
                    upload.responseData { (response) in
                        if let value = response.result.value {
                            if let status = response.response?.statusCode {

                                switch status {
                                case 200:
                                    do {
                                        let decoder = JSONDecoder()
                                        let result = try decoder.decode(ResponseString.self, from: value)
                                        
                                        switch result.success {
                                        case true:
                                            print(result.message)
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
    
    func getDiary(date: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let URL = APIConstants.DiaryDetailURL + "/\(date)"
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/x-www-form-urlencoded",
            "token" : UserDefaults.standard.string(forKey: "token")!
        ]
        
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
                                    let result = try decoder.decode(ResponseArray<Diary>.self, from: value)

                                    switch result.success {
                                    case true:
                                        completion(.success(result.data![0]))
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
    
    func deleteDiary(date: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let URL = APIConstants.DiaryDeleteURL + "/\(date)"
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/x-www-form-urlencoded",
            "token" : UserDefaults.standard.string(forKey: "token")!
        ]
        
        Alamofire.request(URL, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: header)
            .responseData { response in
                switch response.result {
                    
                case .success:
                    if let value = response.result.value {
                        if let status = response.response?.statusCode {
                            
                            switch status {
                            case 200:
                                do {
                                    let decoder = JSONDecoder()
                                    let result = try decoder.decode(ResponseString.self, from: value)
                                    
                                    switch result.success {
                                    case true:
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
    
    func getDiaryList(date: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let URL = APIConstants.DiaryListURL + "/\(date)"
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/x-www-form-urlencoded",
            "token" : UserDefaults.standard.string(forKey: "token")!
        ]
        
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
                                    let result = try decoder.decode(ResponseArray<Diary>.self, from: value)
                                    
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
}



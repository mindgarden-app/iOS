//
//  AuthService.swift
//  MindGarden
//
//  Created by Sunghee Lee on 12/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import Foundation
import Alamofire

struct AuthService {
    
    static let shared = AuthService()
    let header: HTTPHeaders = [
        "Content-Type" : "application/x-www-form-urlencoded",
    ]
    
    func login(email: String, password: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let body: Parameters = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(APIConstants.LoginURL, method: .post, parameters: body, encoding: URLEncoding.httpBody, headers: header)
            .responseData { response in
                print(response)
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        if let status = response.response?.statusCode {
                            switch status {
                            case 200:
                                do {
                                    let decoder = JSONDecoder()
                                    let result = try decoder.decode(ResponseArray<Login>.self, from: value)
                                    
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
    
    func signup(email: String, password: String, name: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let body: Parameters = [
            "email": email,
            "password": password,
            "name": name
        ]
        
        Alamofire.request(APIConstants.SignupURL, method: .post, parameters: body, encoding: URLEncoding.httpBody, headers: header)
            .responseData { response in
                print(response)
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        if let status = response.response?.statusCode {
                            switch status {
                            case 200:
                                do {
                                    let decoder = JSONDecoder()
                                    let result = try decoder.decode(DefaultRes.self, from: value)
                                    
                                    switch result.success {
                                    case true:
                                        print(result.message)
                                        completion(.success(result.message))
                                    case false:
                                        print(result.message)
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
    
    func resetPassword(email: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let body: Parameters = [
            "email": email,
        ]
        
        Alamofire.request(APIConstants.ResetPasswordURL, method: .post, parameters: body, encoding: URLEncoding.httpBody, headers: header)
            .responseData { response in
                print(response)
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
                                        print(result.message)
                                        completion(.success(result.message))
                                    case false:
                                        print(result.message)
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
    
    func resetPasscode(completion: @escaping (NetworkResult<Any>) -> Void) {
        let header_incld_token: HTTPHeaders = [
            "Content-Type" : "application/x-www-form-urlencoded",
            "token" : UserDefaults.standard.string(forKey: "token")!
        ]
        
        Alamofire.request(APIConstants.ResetPasscodeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header_incld_token)
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
                                        completion(.success(result.data))
                                    case false:
                                        completion(.requestErr(result.message))
                                    }
                                } catch {
                                    print(error)
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
    
    func deleteUser(completion: @escaping (NetworkResult<Any>) -> Void) {
        let URL = APIConstants.UserDeleteURL
        
        let header_incld_token: HTTPHeaders = [
            "Content-Type" : "application/x-www-form-urlencoded",
            "token" : UserDefaults.standard.string(forKey: "token")!
        ]
        
        Alamofire.request(URL, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: header_incld_token)
            .responseData { response in
                switch response.result {
                    
                case .success:
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

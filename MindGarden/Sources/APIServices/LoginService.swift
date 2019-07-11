//
//  LoginService.swift
//  MindGarden
//
//  Created by Sunghee Lee on 08/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import Foundation
import Alamofire

struct LoginService {
    
    static let shared = LoginService()
    let header: HTTPHeaders = [
        "Content-Type" : "application/x-www-form-urlencoded"
    ]
    
    func login(completion: @escaping (NetworkResult<Any>) -> Void) {
        
        Alamofire.request(APIConstants.KaKaoLoginURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
            .responseData { response in
                
                print(response.result)
                switch response.result {
                    
                case .success:
                    if let value = response.result.value {
                        if let status = response.response?.statusCode {
                            print(status)
                            print(value)
                            
                            switch status {
                            case 200:
                                do {
                                    let decoder = JSONDecoder()
                                    let result = try decoder.decode(ResponseString.self, from: value)

                                    print(result)
                                    switch result.success {
                                    case true:
                                        print(result.message)
                                        completion(.success(result.data!))
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
}

//
//  NetworkResult.swift
//  MindGarden
//
//  Created by Sunghee Lee on 06/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}


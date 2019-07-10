//
//  Login.swift
//  MindGarden
//
//  Created by Sunghee Lee on 09/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

struct User: Codable {
    let userIdx: Int
}

struct Login: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: User
}

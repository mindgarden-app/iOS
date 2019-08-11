//
//  Login.swift
//  MindGarden
//
//  Created by Sunghee Lee on 09/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

struct Login: Codable {
    let refreshToken: String
    let token: String
    let name: String
    let email: String
    let expires_in: Int
}

//
//  ResponseString.swift
//  MindGarden
//
//  Created by Sunghee Lee on 06/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

struct ResponseString: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: String?
}

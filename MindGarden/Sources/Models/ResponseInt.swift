//
//  ResponseInt.swift
//  MindGarden
//
//  Created by Sunghee Lee on 2020/03/04.
//  Copyright © 2020 Sunghee Lee. All rights reserved.
//

struct ResponseInt: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: Int?
}

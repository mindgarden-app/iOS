//
//  Diary.swift
//  MindGarden
//
//  Created by Sunghee Lee on 10/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

struct Diary: Codable {
    let diaryIdx: Int
    let date: String
    let diary_content: String
    let weatherIdx: Int
    let userIdx: Int
    let diary_img: String?
}

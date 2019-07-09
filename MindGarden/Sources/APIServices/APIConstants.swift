//
//  APIConstants.swift
//  MindGarden
//
//  Created by Sunghee Lee on 06/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

struct APIConstants {
    static let BaseURL = "http://13.125.190.74:3000"
    
    static let AuthURL = BaseURL + "/auth"
    static let KaKaoLoginURL = AuthURL + "/login/kakao"
    static let LogoutURL = AuthURL + "/mail"
    
    static let GardenURL = BaseURL + "/garden"
    static let GardenAddURL = GardenURL + "/plant"
    
    static let DiaryURL = BaseURL + "/diary"
    static let DiaryDetailURL = DiaryURL + "/click"
    static let DiaryListURL = BaseURL + "/diarylist"
    static let DiaryDeleteURL = DiaryListURL + "/delete"
    static let DiaryAddURL = DiaryURL + "/save"
    static let DiaryEditURL = DiaryURL + "/complete"
}

//
//  APIConstants.swift
//  MindGarden
//
//  Created by Sunghee Lee on 06/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

struct APIConstants {
    static let BaseURL = "http://hyunjkluz.ml:2424/api"
    static let AuthURL = BaseURL + "/auth"
    static let LoginURL = AuthURL + "/signin"
    static let WebtoonURL = BaseURL + "/webtoons"
    static let WebtoonMainURL = WebtoonURL + "/main"
    static let EpisodeURL = WebtoonURL + "/episodes"
    static let CommentURL = EpisodeURL + "/cmts"
}

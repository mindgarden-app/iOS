//
//  NetworkResult.swift
//  MindGarden
//
//  Created by Sunghee Lee on 06/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

enum NetworkResult<T> {
    // 통신의 상태에 대한 분기 코드입니다.
    case success(T)
    // 요청이 맞지 않은 경우(ex.아이디와 비밀번호가 틀린 경우) generic경우에는 사용자에게 무엇을 줘야하는 경우(메시지 같은 것)
    case requestErr(T)
    // 서버나 나에게 오타가 있을 때 404의 경우
    case pathErr
    // 서버에 에러가 있을 때
    case serverErr
    // 인터넷이 꺼져있는 상태, 서버가 꺼진 상태..
    case networkFail
}


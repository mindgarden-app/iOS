<div align="center"><img src="https://s3.ap-northeast-2.amazonaws.com/github.readme.image/mindgarden/mindgarden_ios_appicon_180.png" width="80" /></div>
<h1 align="center">Mind Garden</h1>
<p align="center">
   <img src="https://img.shields.io/badge/swift-v5.0.1-blue"/>
   <img src="https://img.shields.io/badge/xcode-v10.2.1-blue"/>
   <img src="https://img.shields.io/badge/download-15294-success"/>
   <a href="https://www.mindgarden11.net"><img src="https://img.shields.io/badge/-공식 홈페이지-green"/></a>
   <br/>
   <br/>
   <i>
      <samp>
         <b>Mind Garden</b>은 하루의 이야기로 나만의 정원을 가꿔나가는 🌱<b>힐링 다이어리앱</b>🌱입니다. <br/>
         매일 일기를 기록하고 받은 나무와 꽃을 통해 정원을 가꿔나갈 수 있습니다. <br/>
         정원은 달마다 리셋되며, 지난 정원은 앱 내에서 항상 볼 수 있습니다. <br/>
         일기에서 날씨로 나의 상태를 기록하고 아름다운 나무와 꽃을 받아보세요! 
         매일 기록할 수록 정원이 더욱 풍요로워집니다.
      </samp>
   </i>
</p>
   <h1 align="center">🎊 🥳 🎊 🥳 🎊 🥳 🎊 🥳 </h1>
   <p align="center">
      <samp>
         1. 2019.08.27 : 배포 <br/>
         2. 2020.01.18 : 앱스토어 <b>'이번 주 에디터의 발견'</b> 추천 🎉 <br/>
<img src="https://s3.ap-northeast-2.amazonaws.com/github.readme.image/mindgarden/IMG_2203.jpg" alt="drawing" width="200"/> <img src="https://s3.ap-northeast-2.amazonaws.com/github.readme.image/mindgarden/IMG_2201.jpg" alt="drawing" width="250"/><br/><br/>
         3. 2020.03.16 : 앱스토어 투데이 추천 + <b>18위</b> 🎉 <br/>
<img src="https://s3.ap-northeast-2.amazonaws.com/github.readme.image/mindgarden/IMG_2476.jpg" alt="drawing" width="200"/> <img src="https://s3.ap-northeast-2.amazonaws.com/github.readme.image/mindgarden/IMG_2541.jpg" alt="drawing" width="250"/> <img src="https://s3.ap-northeast-2.amazonaws.com/github.readme.image/mindgarden/IMG_2503.JPG" alt="drawing" width="300"/><br/><br/>
         4. 2020.03.24 : 앱스토어 투데이 <b>오늘의 앱</b> 선정 🎉 <br/>
<img src="https://s3.ap-northeast-2.amazonaws.com/github.readme.image/mindgarden/IMG_2526.jpg" alt="drawing" width="250"/><br/><br/>
         5. 2020.06.20 : 앱스토어 투데이 <b>오늘의 앱</b> 선정 🎉 <br/>
         6. 2020.08.14 : 앱스토어 투데이 추천 🎉 <br/>
         7. 2020.08.21 : 앱스토어 서비스 종료
      </samp>
   </p>
<br/>
  

## Table of Contents

1. [About](#about)

2. [Folder Structure](#folder-structure)

3. [Features](#features)

<br/>

## About

- 개발자 : [이성희](https://github.com/Sunghee2)
- 개발 기간 : 2019년 6월 29일 ~ 2019년 7월 12일
- 운영 기간 : 2019년 8월 27일 ~ 2020년 8월 21일
<br/>

## Folder Structure

```
MindGarden
|-- MindGarden.xcodeproj
|   |-- project.xcworkspace
|   |   `-- contents.xcworkspacedata
|-- Resources
|   |-- Assets.xcassets
|   |-- Storyboards
|   |   |-- LaunchScreen.storyboard
|   |   |-- Auth.storyboard
|   |   |-- Main.storyboard
|   |   |-- Diary.storyboard
|   |   |-- Lock.storyboard
|   |   `-- Settings.storyboard
|   `-- Info.plist
|-- Sources
|   |-- APIServices
|   |   |-- APIConstants.swift
|   |   |-- DiaryService.swift
|   |   |-- GardenService.swift
|   |   `-- AuthService.swift
|   |-- Extensions
|   |   |-- Date+Extensions.swift
|   |   |-- UIColor+Extensions.swift
|   |   |-- UITableView+Extensions.swift
|   |   |-- UIView+Extensions.swift
|   |   |-- NSMutableAttributedString+Extensions.swift
|   |   |-- String+Extensions.swift
|   |   `-- UIViewController+Extensions.swift
|   |-- Models
|   |   |-- DefaultRes.swift
|   |   |-- Diary.swift
|   |   |-- Login.swift
|   |   |-- Grid.swift
|   |   |-- NetworkResult.swift
|   |   |-- ResponseArray.swift
|   |   |-- ResponseString.swift
|   |   |-- Token.swift
|   |   `-- Tree.swift
|   |-- ViewControllers
|   |   |-- Diary
|   |   |   |-- DiaryDetailVC.swift
|   |   |   |-- DiaryListVC.swift
|   |   |   |-- DiaryNewVC.swift
|   |   |   `-- DiaryPopUpVC.swift
|   |   |-- Lock
|   |   |   `-- LockVC.swift
|   |   |-- Auth
|   |   |   |-- SignupVC.swift
|   |   |   |-- EmailLoginVC.swift
|   |   |   |-- ResetPw1VC.swift
|   |   |   |-- ResetPw2VC.swift
|   |   |   |-- PolicyVC.swift
|   |   |   `-- LoginVC.swift
|   |   |-- Main
|   |   |   |-- MainGridVC.swift
|   |   |   |-- MainVC.swift
|   |   |   `-- PopUpVC.swift
|   |   `-- Settings
|   |   |   |-- SettingsDetailVC.swift
|   |   |   `-- SettingsVC.swift
|   |-- Views
|   |   |-- Diary
|   |   |   |-- DiaryListTVC.swift
|   |   |   |-- DiaryListTVC.xib
|   |   |   |-- DiaryPopUpTVC.swift
|   |   |   `-- DiaryPopUpTVC.xib
|   |   |-- Lock
|   |   |   |-- LockCodeCVC.swift
|   |   |   `-- LockCodeCVC.xib
|   |   |-- Login
|   |   |   |-- DescriptionSlide.swift
|   |   |   `-- DescriptionSlide.xib
|   |   |-- Main
|   |   |   |-- TreeCVC.swift
|   |   |   `-- TreeCVC.xib
|   |   `-- Settings
|   |   |   |-- DatePickerTVC.swift
|   |   |   |-- DatePickerTVC.xib
|   |   |   |-- ProfileTVC.swift
|   |   |   |-- ProfileTVC.xib
|   |   |   |-- SettingsFontTVC.swift
|   |   |   |-- SettingsFontTVC.xib
|   |   |   |-- SettingsTVC.swift
|   |   |   |-- SettingsTVC.xib
|   |   |   |-- SettingsWithSwitchTVC.swift
|   |   `   `-- SettingsWithSwitchTVC.xib
`   |-- AppDelegate.swift
`   `-- AppConstants.swift
```

<br/>

## Features

- 회원 관련
  
  - [x] 회원가입
  - [x] 이메일 로그인
  - [x] Kakao 로그인
  - [x] Apple 로그인
  - [x] 비밀번호 찾기
  - [x] 로그아웃
  - [x] 탈퇴
  
- 메인 화면

  - [x] 현재 달 정원 보여주기
  - [x] 정원에 있는 나무 수에 따라 문구 변경
  - [x] 보고 싶은 정원의 날짜(년, 월) 선택
  - [x] 일기를 쓴 경우(나무를 심을 수 있는 경우) 아이콘 변경

  - [x] 심고 싶은 나무 선택
  - [x] 나무를 심을 위치 선택
  
  - [x] 봄 시즌 정원

  > 달 별로 정원을 확인할 수 있습니다. 
  >
  > 일기를 작성하면 나무를 정원에 심을 수 있습니다.

- 일기
  - [x] 일기 작성
    - [x] 오늘의 기분 선택
    - [x] 사진 삽입
  - [x] 일기 수정
  - [x] 일기 삭제 (스와이프)
  - [x] 일기 목록
    - [x] 달 별로 일기 목록 확인 
    - [x] 일 별로 정렬
  - [x] 일기 상세 보기 

  > 일기는 여러 개 작성 가능

- 환경 설정
  - [x] 프로필 확인 (이름, 이메일)
  - [x] 앱 암호 설정
    - [x] 암호 설정 
    - [x] 암호 변경
    - [x] 암호 분실시 비밀번호 재설정
  - [x] 알림 설정 
    - [x] 시간 설정
    - [x] 푸시 알림
    - [x] 알림 뱃지
  - [x] 글꼴 설정
    - [x] 글씨 크기 변경
  - [x] 버전 확인
  
- 기타

  - [x] 스와이프로 뒤로가기
  - [x] firebase crashlytics

<br/>




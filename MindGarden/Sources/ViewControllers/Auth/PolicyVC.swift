//
//  ToSVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 08/08/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class PolicyVC: UIViewController {

    @IBOutlet var policyText: UITextView!
    
    var policyNum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
    }
    
    func setView() {
        
        if policyNum == 1 {
            self.navigationItem.title = "이용약관"
            
            let attributedString = NSMutableAttributedString(string: "Mindgarden 서비스 이용약관\n\n・제1장 총칙\n \n제1조 (목적) \n이 약관은 Mindgarden(이하 “회사”라 합니다)가 모바일 기기를 통해 제공하는 모바일 서비스 및 이에 부수하는 네트워크, 웹사이트, 기타 서비스(이하 “서비스”라 합니다)의 이용에 대한 회사와 서비스 이용자의 권리ㆍ의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 합니다.\n \n제2조 (용어의 정의) \n이 약관에서 사용하는 용어의 정의는 다음과 같습니다.\n      1. “회사”라 함은 모바일 기기를 통하여 서비스를 제공하는 사업자를 의미합니다.\n      2. “회원”이란 이 약관에 따라 이용계약을 체결하고, 회사가 제공하는 서비스를 이용하는 자를 의미합니다.\n      3.  아이디 (ID) : “ 회원”의 식별과 “회원”의 서비스를 위한 E-mail ( 전자메일 ) 주소를 의미합니다 .\n      4.  비밀번호 ( PASSWORD ) : “회원”을 식별하는 “아이디”와 일치하는 “회원”임을 확인하고 비밀보호를 위해 “회원”자신이 정한 8자리 이상의 문자 또는 숫자를 의미합니다.\n      5. 운영자 : “서비스” 의 전반적인 관리와 원활한 운영을 위하여 회사에서 선정한 자를 의미합니다. \n      6. 게시물 : “회원”이 본 “ 서비스”에 게제한 문자 조합으로 이루어진 정보 또는 첨부한 모든 자료를 의미합니다.\n \n제3조 (약관의 효력 및 변경) \n① 회사는 이 약관의 내용을 회원이 알 수 있도록 서비스 내 또는 그 연결화면에 게시합니다.\n② 회사가 약관을 개정할 경우에는 적용일자 및 개정내용, 개정사유 등을 명시하여 최소한 그 적용일 7일 이전부터 게임서비스 내 또는 그 연결화면에 게시하여 회원에게 공지합니다. 다만, 변경된 내용이 회원에게 불리하거나 중대한 사항의 변경인 경우에는 그 적용일 30일 이전까지 본문과 같은 방법으로 공지하고 제27조 제1항의 방법으로 회원에게 통지합니다. 이 경우 개정 전 내용과 개정 후 내용을 명확하게 비교하여 회원이 알기 쉽도록 표시합니다.\n③ 회사가 약관을 개정할 경우 개정약관 공지 후 개정약관의 적용에 대한 회원의 동의 여부를 확인합니다. 회사는 제2항의 공지 또는 통지를 할 경우 회원이 개정약관에 대해 동의 또는 거부의 의사표시를 하지 않으면 동의한 것으로 볼 수 있다는 내용도 함께 공지 또는 통지를 하며, 회원이 이 약관 시행일까지 거부의 의사표시를 하지 않는다면 개정약관에 동의한 것으로 볼 수 있습니다. 회원이 개정약관에 대해 동의하지 않는 경우 회사 또는 회원은 서비스 이용계약을 해지할 수 있습니다.\n④ 회사는 회원이 회사와 이 약관의 내용에 관하여 질의 및 응답을 할 수 있도록 조치를 취합니다.\n⑤ 회사는 「약관의 규제에 관한 법률」, 「정보통신망이용촉진 및 정보보호 등에 관한 법률」, 「콘텐츠산업진흥법」 등 관련 법령에 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다.\n \n제4조 (이용계약의 체결 및 적용) \n이용계약은 회원이 되고자 하는 자(이하 “가입신청자”라 합니다.)가 이 약관의 내용에 대하여 동의를 한 다음 서비스 이용 신청을 하고, 회사가 그 신청에 대해서 승낙함으로써 체결됩니다.\n\n제5조 (약관 외 준칙) \n이 약관에서 정하지 아니한 사항과 이 약관의 해석에 관하여는「약관의 규제에 관한 법률」,「정보통신망이용촉진 및 정보보호 등에 관한 법률」,「콘텐츠산업진흥법」 등 관련 법령 또는 상 관례에 따릅니다.\n\n\n・제2장 개인정보 관리\n \n제6조 (개인정보의 보호 및 사용) \n① 회사는 관련 법령이 정하는 바에 따라 회원의 개인정보를 보호하기 위해 노력하며, 개인정보의 보호 및 사용에 대해서는 관련 법령 및 회사의 개인정보처리방침에 따릅니다. 다만, 회사가 제공하는 서비스 이외의 링크된 서비스에서는 회사의 개인정보처리방침이 적용되지 않습니다.\n②회사는 관련 법령에 의해 관련 국가기관 등의 요청이 있는 경우를 제외하고는 회원의 개인정보를 본인의 동의 없이 타인에게 제공하지 않습니다.\n③회사는 회원의 귀책사유로 개인정보가 유출되어 발생한 피해에 대하여 책임을 지지 않습니다.\n \n\n・제3장 이용계약 당사자의 의무\n \n제7조 (회사의 의무) \n① 회사는 관련 법령, 이 약관에서 정하는 권리의 행사 및 의무의 이행을 신의에 따라 성실하게 준수합니다.\n② 회사는 회원이 안전하게 서비스를 이용할 수 있도록 개인정보(신용정보 포함)보호를 위해 보안시스템을 갖추어야 하며 개인정보처리방침을 공시하고 준수합니다. 회사는 이 약관 및 개인정보처리방침에서 정한 경우를 제외하고는 회원의 개인정보가 제3자에게 공개 또는 제공되지 않도록 합니다.\n③ 회사는 계속적이고 안정적인 서비스의 제공을 위하여 서비스 개선을 하던 중 설비에 장애가 생기거나 데이터 등이 멸실․훼손된 때에는 천재지변, 비상사태, 현재의 기술로는 해결이 불가능한 장애나 결함 등 부득이한 사유가 없는 한 지체 없이 이를 수리 또는 복구하도록 최선의 노력을 다합니다.\n\n제8조 (회원의 의무) \n① 회원은 회사에서 제공하는 서비스의 이용과 관련하여 다음 각 호에 해당하는 행위를 해서는 안 됩니다.\n      1. 이용신청 또는 회원 정보 변경 시 허위사실을 기재하는 행위\n      2. 서비스를 무단으로 영리, 영업, 광고, 홍보, 정치활동, 선거운동 등 본래의 용도 이외의 용도로 이용하는 행위\n      3. 회사의 서비스를 이용하여 얻은 정보를 무단으로 복제․유통․조장하거나 상업적으로 이용하는 행위, 알려지거나 알려지지 않은 버그를 악용하여 서비스를 이용하는 행위\n      4. 법령에 의하여 전송 또는 게시가 금지된 정보(컴퓨터 프로그램)나 컴퓨터 소프트웨어⋅하드웨어 또는 전기통신장비의 정상적인 작동을 방해⋅파괴할 목적으로 고안된 바이러스⋅컴퓨터 코드⋅파일⋅프로그램 등을 고의로 전송⋅게시⋅유포 또는 사용하는 행위\n      5. 회사로부터 특별한 권리를 부여 받지 않고 애플리케이션을 변경하거나, 애플리케이션에 다른 프로그램을 추가⋅삽입하거나, 서버를 해킹⋅역설계하거나, 소스 코드나 애플리케이션 데이터를 유출⋅변경하거나, 별도의 서버를 구축하거나, 웹사이트의 일부분을 임의로 변경⋅도용하여 회사를 사칭하는 행위\n      6. 그 밖에 관련 법령에 위반되거나 선량한 풍속 기타 사회통념에 반하는 행위\n\n\n・제4장 손해배상 및 면책조항 등\n \n제9조 (손해배상) \n① 회사 또는 회원은 본 약관을 위반하여 상대방에게 손해를 입힌 경우에는 그 손해를 배상할 책임이 있습니다. 다만, 고의 또는 과실이 없는 경우에는 그러하지 아니 합니다\n② 회사가 개별서비스 제공자와 제휴 계약을 맺고 회원에게 개별서비스를 제공하는 경우에 회원이 이 개별서비스 이용약관에 동의를 한 뒤 개별서비스 제공자의 고의 또는 과실로 인해 회원에게 손해가 발생한 경우에 그 손해에 대해서는 개별서비스 제공자가 책임을 집니다.\n\n제10조 (회사의 면책) \n① 회사는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관하여 책임을 지지 않습니다.\n② 회사는 서비스용 설비의 보수, 교체, 정기점검, 공사 등 기타 이에 준하는 사유로 발생한 손해에 대하여 책임을 지지 않습니다. 다만, 회사의 고의 또는 과실에 의한 경우에는 그러하지 아니합니다.\n③ 회사는 회원의 고의 또는 과실로 인한 서비스 이용의 장애에 대하여는 책임을 지지 않습니다. 다만, 회원에게 부득이하거나 정당한 사유가 있는 경우에는 그러하지 아니합니다.\n ④ 회원이 서비스와 관련하여 게재한 정보나 자료 등의 신뢰성, 정확성 등에 대하여 회사는 고의 또는 중대한 과실이 없는 한 책임을 지지 않습니다.\n⑤ 회사는 회원이 다른 회원 또는 타인과 서비스를 매개로 발생한 거래나 분쟁에 대해 개입할 의무가 없으며, 이로 인한 손해에 대해 책임을 지지 않습니다.\n⑥ 회사는 무료로 제공되는 서비스 이용과 관련하여 회원에게 발생한 손해에 대해서는 책임을 지지 않습니다. 그러나 회사의 고의 또는 중과실에 의한 경우에는 그러하지 아니합니다.\n\n \n\n\n \n\n\n", attributes: [
                .font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 13.5)!,
                .foregroundColor: UIColor(white: 41.0 / 255.0, alpha: 1.0)
                ])
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 17.0)!, range: NSRange(location: 0, length: 20))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 20, length: 9))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 31, length: 8))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 204, length: 12))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 688, length: 19))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 1436, length: 21))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 1562, length: 13))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 1690, length: 13))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 1705, length: 21))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 2011, length: 18))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 2031, length: 12))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 2426, length: 12))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 3072, length: 19))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 3093, length: 12))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 3347, length: 13))
            
            policyText.attributedText = attributedString
        } else {
            self.navigationItem.title = "개인정보처리방침"
            
            let attributedString = NSMutableAttributedString(string: "Mindgarden 개인정보처리방침\n\n‘MindGarden’이하 ‘Mindgarden’은 개인정보보호법에 따라 이용자의 개인정보 보호 및 권익을 보호하고 개인정보와 관련한 이용자의 고충을 원활하게 처리할 수 있도록 다음과 같은 처리방침을 두고 있습니다. ‘Mindgarden’은 회사는 개인정보처리방침을 개정하는 경우 웹사이트 공지사항(또는 개별공지)을 통하여 공지할 것입니다.\n・본 방침은부터 2019년 9월 1일부터 시행됩니다.\n\n1. 개인정보의 처리 목적 \n‘Mindgarden’은 개인정보를 다음의 목적을 위해 처리합니다. 처리한 개인정보는 다음의 목적이외의 용도로는 사용되지 않으며 이용 목적이 변경될 시에는 사전동의를 구할 예정입니다.\n      가. 홈페이지 회원가입 및 관리\n회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증 등을 목적으로 개인정보를 처리합니다.\n\n2. 개인정보 파일 현황\n      1. 개인정보 파일명 : 이메일,비밀번호\n      - 개인정보 항목 : 이메일, 비밀번호\n      - 수집방법 : 홈페이지\n      - 보유근거 : 회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증 등을 목적으로 개인정보를 처리합니다.\n      - 보유기간 : 1년\n      - 관련법령 : 신용정보의 수집/처리 및 이용 등에 관한 기록 : 3년\n\n3. 개인정보의 처리 및 보유 기간\n① ‘Mindgarden’은 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집시에 동의 받은 개인정보 보유,이용기간 내에서 개인정보를 처리,보유합니다.\n② 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.\n      1.<홈페이지 회원가입 및 관리>\n      <홈페이지 회원가입 및 관리>와 관련한 개인정보는 수집.이용에 관한 동의일로부터<1년>까지 위 이용목적을 위하여 보유.이용됩니다.\n      -보유근거 : 회원제 서비스 제공에 따른 본인 식별·인증 등을 목적으로 개인정보를 처리합니다.\n      -관련법령 : 신용정보의 수집/처리 및 이용 등에 관한 기록 : 3년\n\n4. 정보주체와 법정대리인의 권리·의무 및 그 행사방법 이용자는 개인정보주체로써 다음과 같은 권리를 행사할 수 있습니다.\n① 정보주체는 ‘Mindgarden’에 대해 언제든지 개인정보 열람,정정,삭제,처리정지 요구 등의 권리를 행사할 수 있습니다.\n② 제1항에 따른 권리 행사는 ‘Mindgarden’에 대해 개인정보 보호법 시행령 제41조제1항에 따라 서면, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며, ‘Mindgarden’은 이에 대해 지체 없이 조치하겠습니다.\n③ 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다. 이 경우 개인정보 보호법 시행규칙 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다.\n④ 개인정보 열람 및 처리정지 요구는 개인정보보호법 제35조 제5항, 제37조 제2항에 의하여 정보주체의 권리가 제한 될 수 있습니다.\n⑤ 개인정보의 정정 및 삭제 요구는 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 그 삭제를 요구할 수 없습니다.\n⑥ ‘Mindgarden’은 정보주체 권리에 따른 열람의 요구, 정정·삭제의 요구, 처리정지의 요구 시 열람 등 요구를 한 자가 본인이거나 정당한 대리인인지를 확인합니다.\n\n5. 처리하는 개인정보의 항목 작성 \n‘Mindgarden’은 다음의 개인정보 항목을 처리하고 있습니다.\n      1.<홈페이지 회원가입 및 관리>\n      - 필수항목 : 이메일, 비밀번호\n\n6. 개인정보의 파기\n‘Mindgarden’은 원칙적으로 개인정보 처리목적이 달성된 경우에는 지체없이 해당 개인정보를 파기합니다. 파기의 절차, 기한 및 방법은 다음과 같습니다.\n      - 파기절차 : 이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져(종이의 경우 별도의 서류) 내부 방침 및 기타 관련 법령에 따라 일정기간 저장된 후 혹은 즉시 파기됩니다. 이 때, DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다.\n      - 파기기한 : 이용자의 개인정보는 개인정보의 보유기간이 경과된 경우에는 보유기간의 종료일로부터 5일 이내에, 개인정보의 처리 목적 달성, 해당 서비스의 폐지, 사업의 종료 등 그 개인정보가 불필요하게 되었을 때에는 개인정보의 처리가 불필요한 것으로 인정되는 날로부터 5일 이내에 그 개인정보를 파기합니다.\n      - 파기방법 : 전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다.\n\n7. 개인정보 자동 수집 장치의 설치·운영 및 거부에 관한 사항\n‘Mindgarden’은 정보주체의 이용정보를 저장하고 수시로 불러오는 ‘쿠키’를 사용하지 않습니다.\n\n8. 개인정보 보호책임자 작성\n‘Mindgarden’은 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.\n      ▶ 개인정보 보호책임자 \n      성명 :김채윤\n      직책 :pm\n      직급 :pm\n      연락처 :mindgarden2019@gmail.com \n      ※ 개인정보 보호 담당부서로 연결됩니다.\n\n9. 개인정보 처리방침 변경\n이 개인정보처리방침은 시행일로부터 적용되며, 법령 및 방침에 따른 변경내용의 추가, 삭제 및 정정이 있는 경우에는 변경사항의 시행 7일 전부터 공지사항을 통하여 고지할 것입니다.\n\n10. 개인정보의 안전성 확보 조치 \n‘Mindgarden’은 개인정보보호법 제29조에 따라 다음과 같이 안전성 확보에 필요한 기술적/관리적 및 물리적 조치를 하고 있습니다.\n      1. 개인정보의 암호화\n이용자의 개인정보는 비밀번호는 암호화 되어 저장 및 관리되고 있어, 본인만이 알 수 있으며 중요한 데이터는 파일 및 전송 데이터를 암호화 하거나 파일 잠금 기능을 사용하는 등의 별도 보안기능을 사용하고 있습니다.", attributes: [
                .font: UIFont(name: "NotoSansCJKkr-DemiLight", size: 13.5)!,
                .foregroundColor: UIColor(white: 41.0 / 255.0, alpha: 1.0)
                ])
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 17.0)!, range: NSRange(location: 0, length: 20))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 243, length: 14))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 444, length: 14))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 672, length: 20))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 1031, length: 68))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 1661, length: 21))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 1771, length: 12))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 2271, length: 36))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 2365, length: 17))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 2618, length: 16))
            attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-Medium", size: 13.5)!, range: NSRange(location: 2735, length: 21))
            
            policyText.attributedText = attributedString
        }
        
        
        policyText.frame.size.height = UIScreen.main.bounds.size.height - 150
        print(policyText.contentSize.height)
        print(policyText.frame.size.height)
    }

    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

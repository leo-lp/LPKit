//
//  String+UnicodeTests.swift
//  LPKitDemoTests
//
//  Created by pengli on 2018/5/21.
//  Copyright © 2018年 pengli. All rights reserved.
//

import XCTest

class String_UnicodeTests: LPKitDemoBaseTests {
    
    func testUnicode() {
        let originalString = "String+Unicode -> 字符串+Unicode编码"
        print("unicode=\(originalString.lp_unicode)")
    }
}

//
//  LPURLParameterParseTests.swift
//  LPKitDemoTests
//
//  Created by pengli on 2018/5/21.
//  Copyright © 2018年 pengli. All rights reserved.
//

import XCTest
import LPKit

class LPURLParameterParseTests: LPKitDemoBaseTests {
    let urlString = "http://example.com?param1=value1&param2=value2&param2=value2_2&param2=value2_3&param3=value3"
    
    func testURLString() {
        let parameters = urlString.urlParameters
        print("urlParameters=\(String(describing: parameters))")
    }
    
    func testURL() {
        guard let url = URL(string: urlString) else { return }
        let parameters = url.urlParameters
        print("urlParameters=\(String(describing: parameters))")
    }
    
    func testURLComponents() {
        guard let url = URLComponents(string: urlString) else { return }
        let parameters = url.urlParameters
        print("urlParameters=\(String(describing: parameters))")
    }
    
}

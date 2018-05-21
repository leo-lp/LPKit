//
//  Int+LPKit.swift
//  LPKit <https://github.com/leo-lp/LPKit>
//
//  Created by pengli on 2018/5/21.
//  Copyright © 2018年 pengli. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation

public extension Int {
    
    /// 数字格式化：100,000,000
    func lp_toDecimal() -> String {
        let number = NSNumber(value: self)
        
        let format = NumberFormatter()
        format.usesGroupingSeparator = true
        format.groupingSeparator = ","
        format.groupingSize = 3
        //format.numberStyle = NumberFormatter.Style.decimal
        
        let formatStr = format.string(from: number)
        return formatStr ?? "\(self)"
    }
    
    /// 获取Int类型每一位的数值
    func lp_numberBits() -> [Int] {
        var bits: [Int] = []
        var num = self
        while num > 0 {
            bits.append(num % 10)
            num = num / 10
        }
        return bits
    }
}

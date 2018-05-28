//
//  String+LPKit.swift
//  LPKit <https://github.com/leo-lp/LPKit>
//
//  Created by pengli on 2018/5/21.
//  Copyright © 2018年 pengli. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import UIKit

public extension String {
    
    /// 获取字符串的尺寸
    ///
    /// - Parameter font: 字体UIFont
    /// - Returns: 字符串宽度
    func lp_textSize(with font: UIFont) -> CGSize {
        let greatest = CGFloat.greatestFiniteMagnitude
        let size = CGSize(width: greatest, height: greatest)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let attributes: [NSAttributedStringKey: Any] = [.font: font]
        
        let rect = self.boundingRect(with: size,
                                     options: options,
                                     attributes: attributes,
                                     context: nil)
        return rect.size
    }

    /// 获取所有匹配的子字符串的Range
    ///
    /// - Parameters:
    ///   - subString: 子字符串
    ///   - block: 返回匹配的子字符串的Range
    /// - Returns: true用户在Block里强制停止函数的执行，false函数调用完自动停止
    @discardableResult
    func lp_enumerateRanges(of subString: String,
                            block: @escaping (_ range: Range<String.Index>, _ isStop: inout Bool) -> Void) -> Bool {
        
        var isForceStop: Bool = false
        
        /// 通过递归获取所有子字符串location
        func recursiveRange(with range: Range<String.Index>) {
            
            /// 获取指定范围内第一个匹配的子字符串range
            guard let subRange = self.range(of: subString, range: range)
                else { return }
            
            block(subRange, &isForceStop)
            
            guard subRange.upperBound < range.upperBound, !isForceStop
                else { return }
            recursiveRange(with: subRange.upperBound..<range.upperBound)
        }
        
        recursiveRange(with: startIndex..<endIndex)
        return isForceStop
    }
    
    func lp_subString(start: Int, end: Int) -> String? {
        return self[start, end]
    }
    
    subscript (start: Int, end: Int) -> String? {
        guard start >= 0
            && start < end
            && start < count else { return nil }
        let end = end >= count ? count : end
        
        let beginIndex = index(startIndex, offsetBy: start)
        let endIndex = index(startIndex, offsetBy: end)
        
        return String(self[beginIndex..<endIndex])
    }
}

// MARK: - 获取字符串的拼音首字母

public extension String {

    /// 获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
    ///
    /// - Returns: 首字母（注：如果首字符不是字母，则返回'#'）
    var lp_firstLetterOfPinyin: String {
        // 转成了可变字符串
        let str = NSMutableString(string: self)
        
        // 先转换为带声调的拼音
        CFStringTransform(str, nil, kCFStringTransformMandarinLatin, false)
        
        // 再转换为不带声调的拼音
        CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false)
        
        if str.length > 0 {
            // 转化为大写拼音
            let firstPinYin = str.substring(to: 1).capitalized
            return firstPinYin.lp_isLetterOfFirstCharacter ? firstPinYin : "#"
        }
        return "#"
    }
    
    /// 判断一个字符串是否以字母开头
    ///
    /// - Parameter str: 字符串
    /// - Returns: 判断结果 true以字母开头；false不是以字母开头
    var lp_isLetterOfFirstCharacter: Bool {
        let ZIMU = "^[A-Za-z]+$"
        let regex = NSPredicate(format: "SELF MATCHES %@", ZIMU)
        return regex.evaluate(with: self)
    }
}

// MARK: - 将字符串UNICODE编码

extension String {
    
    /// UNICODE编码
    public var lp_unicode: String {
        guard var data = data(using: .unicode) else { return self }
        //var bytes = data.withUnsafeBytes { [UInt8](UnsafeBufferPointer(start: $0, count: data.count)) }
        var ptr = data.withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8> in
            return bytes
        }
        
        /// 跳过unicode前面的FF-FE两个字节
        ptr += 2
        
        let ptrLen = data.count - 2
        convertToBigEndian(with: ptr, len: ptrLen)
        let encodedString = httpURLEncode(with: ptr, len: ptrLen)
        
        /// 计算有多少个Unicode（\uxxxx这种格式是Unicode写法,表示一个字符,其中xxxx表示一个16进制数字）
        let lenge = encodedString.count / 4
        
        /// 存储所有Unicode
        var arr: [String] = []
        
        /// 拆分
        for i in 0 ..< lenge {
            let start = encodedString.index(encodedString.startIndex, offsetBy: i * 4)
            let end = encodedString.index(start, offsetBy: 4)
            arr.append(String(encodedString[start ..< end]))
        }
        
        /// 在拆分好的Unicode前面插入"\u"字符
        var unicodeStr: String = ""
        for str in arr {
            unicodeStr += "\\u\(str)"
        }
        return unicodeStr
    }
    
    /// 转换到大端
    private func convertToBigEndian(with src: UnsafeMutablePointer<UInt8>, len: Int) {
        if len % 2 != 0 { return }
        var tmp: UInt8
        for i in stride(from: 0, to: len, by: 2) {
            tmp      = src[i]
            src[i]   = src[i+1]
            src[i+1] = tmp
        }
    }
    
    private func httpURLEncode(with src: UnsafeMutablePointer<UInt8>, len: Int) -> String {
        if len == 0 { return "" }
        
        /// 解析URL中的字符
        var buf: String = ""
        for i in 0..<len {
            buf += urlEncodeFormat(src[i])
            if i != len - 1 {
                buf += ""
            }
        }
        return buf
    }
    
    private func urlEncodeFormat(_ value: UInt8) -> String {
        let nDiv = value / 16 // UInt8
        let nMod = value % 16 // UInt8
        return hexString(withDecimal: nDiv) + hexString(withDecimal: nMod)
    }
    
    /// 十进制转十六进制
    private func hexString(withDecimal value: UInt8) -> String {
        var hex: String
        switch value {
        case 0...9:  hex = "\(value)"
        case 10: hex = "a"
        case 11: hex = "b"
        case 12: hex = "c"
        case 13: hex = "d"
        case 14: hex = "e"
        case 15: hex = "f"
        default: hex = "x"
        }
        return hex
    }
}

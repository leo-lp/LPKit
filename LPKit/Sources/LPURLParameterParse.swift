//
//  LPURLParameterParse.swift
//  LPKit <https://github.com/leo-lp/LPKit>
//
//  Created by pengli on 2018/5/21.
//  Copyright © 2018年 pengli. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation

public protocol LPURLParameterParse {
    /// 获取URL参数；支持URLString、URL、URLComponents
    var urlParameters: [AnyHashable : Any]? { get }
    
    var asURLComponents: URLComponents? { get }
}

public extension LPURLParameterParse {
    
    var urlParameters: [AnyHashable : Any]? {
        /// 解析url
        guard let urlComponents = asURLComponents
            , let queryItems = urlComponents.queryItems else {
                return nil
        }
        
        var parameters: [AnyHashable: Any] = [:]
        
        /// 遍历queryItems获取每一项参数的键值对
        queryItems.forEach { (item) in
            
            /// 判断是否有相同的key
            if let existValue = parameters[item.name], let value = item.value {
                
                /// 将相同key的值存入数组中
                if var existValue = existValue as? [Any] {
                    existValue.append(value)
                    parameters[item.name] = existValue
                } else {
                    parameters[item.name] = [existValue, value]
                }
                
            } else {
                parameters[item.name] = item.value
            }
        }
        
        /// 返回解析后的参数字典
        return parameters
    }
    
    var asURLComponents: URLComponents? {
        return nil
    }
}

extension String: LPURLParameterParse {
    public var asURLComponents: URLComponents? {
        return URLComponents(string: self)
    }
}

extension URL: LPURLParameterParse {
    public var asURLComponents: URLComponents? {
        return URLComponents(url: self, resolvingAgainstBaseURL: false)
    }
}

extension URLComponents: LPURLParameterParse {
    public var asURLComponents: URLComponents? {
        return self
    }
}

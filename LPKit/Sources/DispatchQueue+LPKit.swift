//
//  DispatchQueue+LPKit.swift
//  LPKit
//
//  Created by pengli on 2018/5/21.
//  Copyright © 2018年 pengli. All rights reserved.
//

import Dispatch
import Foundation.NSThread

public extension DispatchQueue {
    
    /// 如果当前self是主队列，且线程是主线程，则block将立即被调用
    func lp_safeAsync(_ block: @escaping ()->()) {
        if self === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            async { block() }
        }
    }
    
}

//
//  UIView+LPKit.swift
//  LPKit <https://github.com/leo-lp/LPKit>
//
//  Created by pengli on 2018/5/21.
//  Copyright © 2018年 pengli. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import UIKit.UIView

public extension UIView {
    
    /// 找到自己的VC
    var lp_viewController: UIViewController? {
        var next: UIView? = self
        while let tmpNext = next {
            if let nextResponder = tmpNext.next,
                let vc = nextResponder as? UIViewController {
                return vc
            }
            next = tmpNext.superview
        }
        return nil
    }
    
    /// 视图水平翻转
    func lp_flipHorizontal() {
        transform = CGAffineTransform(scaleX: -1, y: 1)
    }
}

// MARK: - 截图

public extension UIView {
    
    /// 屏幕截图
    func lp_screenshots() -> UIImage? {
        guard let window = UIApplication.shared.lp_currWindow
            else { return nil }
        
        let screen = UIScreen.main
        UIGraphicsBeginImageContextWithOptions(screen.bounds.size,
                                               false,
                                               screen.scale)
        window.drawHierarchy(in: screen.bounds,
                             afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 当前视图截图
    func viewshots() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size,
                                               false,
                                               UIScreen.main.scale)
        drawHierarchy(in: bounds,
                      afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - 给视图添加分隔符

extension UIView {
    enum LPSeparatorLocation: Int {
        case top    = 0
        case left   = 1
        case bottom = 2
        case right  = 3
    }
    
    func lp_addSeparator(_ frame: CGRect) {
        let separator = CALayer()
        separator.frame = frame
        separator.backgroundColor = #colorLiteral(red: 0.8352941176, green: 0.8352941176, blue: 0.8352941176, alpha: 1).cgColor
        layer.addSublayer(separator)
    }
    
    func lp_addSeparator(at location: LPSeparatorLocation) {
        switch location {
        case .top:
            lp_addSeparator(CGRect(x: 0.0,
                                   y: 0.0,
                                   width: frame.size.width,
                                   height: 0.5))
        case .left:
            lp_addSeparator(CGRect(x: 0.0,
                                   y: 0.0,
                                   width: 0.5,
                                   height: frame.size.height))
        case .bottom:
            lp_addSeparator(CGRect(x: 0.0,
                                   y: frame.size.height - 0.5,
                                   width: frame.size.width,
                                   height: 0.5))
        case .right:
            lp_addSeparator(CGRect(x: frame.size.width - 0.5,
                                   y: 0.0,
                                   width: 0.5,
                                   height: frame.size.height))
        }
    }
}

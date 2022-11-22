//
//  CMIC.swift
//  CMICPro
//
//  Created by 李小华 on 2022/11/21.
//

import UIKit

enum UserDarkModeSet : Int {
    case system, light, dark
}

/// 前缀类型
struct CM<Base> {
    var base: Base
    init(_ base: Base) {
        self.base = base
    }
}

/// 利用协议扩展前缀属性
protocol CMCompatible {}
extension CMCompatible {
    static var cm: CM<Self>.Type {
        set {}
        get { CM<Self>.self }
    }
    var cm: CM<Self> {
        set {}
        get { CM(self) }
    }
}

/// 给字符串扩展功能
// 让UIColor拥有CM前缀属性
extension NSObject: CMCompatible {}
extension Notification.Name: CMCompatible {}

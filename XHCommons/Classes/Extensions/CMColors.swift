//
//  CMColors.swift
//  CMICPro
//
//  Created by 李小华 on 2022/11/21.
//
import UIKit

extension CM where Base: UIColor {
    
    static var Main_L: UIColor {
        return UIColor(hexString: "#FFFFFF", alpha: 1)!
    }
    static var Main_D: UIColor {
        return UIColor(hexString: "#2B405D", alpha: 1)!
    }

    static var Main: UIColor {
        UIColor.init(){ trainCollection in
            if trainCollection.userInterfaceStyle == .light {
                return Main_L
            } else {
                return Main_D
            }
        }
    }
    
}

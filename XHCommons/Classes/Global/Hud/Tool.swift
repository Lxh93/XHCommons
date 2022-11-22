//
//  Tool.swift
//  CMICPro
//
//  Created by 李小华 on 2022/11/21.
//

import Toast_Swift

public func ScaleZoom(_ value: CGFloat) -> CGFloat {
    return value * (jk_kScreenW / 375.0)
}

public func SizeMake(_ width : CGFloat, _ height : CGFloat) -> CGSize {
    return CGSize(width: width, height: height)
}

public func toAbsoluteString(_ value: Any?) -> String {
    guard let value = value else {
        return ""
    }
    if value is String {
        return (value as! String)
    }
    if let value = value as? Int {
        return String(value)
    }
    return ""
}

public func showText(_ text:String?, onView: UIView? = nil) {
    DispatchQueue.main.async {
        if let onView = onView {
            onView.makeToast(text)
        } else {
            getLastWindow().makeToast(text)
            if getLastWindow() != getFirstWindow() {
                getFirstWindow().makeToast(text)
            }
        }
    }
}

public func fastPushViewController(_ viewController: UIViewController, animated: Bool = true) {
    UIViewController.jk.topViewController()?.navigationController?.pushViewController(viewController, animated: animated)
}

public func fastPopViewCtl(animated: Bool? = true) {
    UIViewController.jk.topViewController()?.navigationController?.popViewController(animated: true)
}


public func getLastWindow() -> UIWindow {
    let windows = UIApplication.shared.windows
//    JKPrint(windows)
    for window in windows.reversed(){
        if window.bounds == UIScreen.main.bounds{
            return window
        }
    }
    return windows.last ?? UIWindow()
}


public func getFirstWindow() -> UIWindow {
    let windows = UIApplication.shared.windows
    for window in windows {
        if window.bounds == UIScreen.main.bounds{
            return window
        }
    }
    return windows.first ?? UIWindow()
}

/// 返回限定长度的字符串
/// - Parameters:
///   - text: 需要限制的字符串
///   - append: 超出后添加的字符串
///   - itemCharMaxCount: 最大字符串长度
///   - itemMaxChinese: 最大的汉字长度
/// - Returns: 限制完成的字符串
public func limitString(_ text: String, _ append: String?, _ itemCharMaxCount: Int = 20, _ itemMaxChinese: Int = 10) -> String {
    /// 处理字符串长度超过10个的情况
    var length = 0
    var chinseseNum = 0
    for char in text {
        // 判断是否中文，是中文+2 ，不是+1
        let result = "\(char)".lengthOfBytes(using: .utf8) == 3
        if result {
            chinseseNum += 1
        }
        length += result ? 2 : 1
    }
    var newStr = text
//    if length > itemCharMaxCount {
//        newStr = text[..<itemCharMaxCount]
//    }
    if length > itemCharMaxCount {
        newStr = newStr[..<(itemCharMaxCount - min(chinseseNum, itemMaxChinese))] + (append ?? "")
    }
    return newStr
}

extension String {
    
    enum TruncationPosition {
            case head
            case middle
            case tail
        }

    func truncated(limit: Int, position: TruncationPosition = .tail, leader: String = "...") -> String {
        guard self.count > limit else { return self }

        switch position {
        case .head:
            return leader + self.suffix(limit)
        case .middle:
            let headCharactersCount = Int(ceil(Float(limit - leader.count) / 2.0))

            let tailCharactersCount = Int(floor(Float(limit - leader.count) / 2.0))
            
            return "\(self.prefix(headCharactersCount))\(leader)\(self.suffix(tailCharactersCount))"
        case .tail:
            return self.prefix(limit) + leader
        }
    }
    
}

/// 正则匹配
///
/// - Parameters:
///   - regex: 匹配规则
///   - validateString: 匹配对test象
/// - Returns: 返回结果
public func RegularExpression (regex:String,validateString:String) -> [String] {
    do {
        let regex: NSRegularExpression = try NSRegularExpression(pattern: regex, options: [])
        let matches = regex.matches(in: validateString, options: [], range: NSMakeRange(0, validateString.count))
        
        var data:[String] = Array()
        for item in matches {
            let string = (validateString as NSString).substring(with: item.range)
            data.append(string)
        }
        
        return data
    }
    catch {
        return []
    }
}


/// 字符串的替换
///
/// - Parameters:
///   - validateString: 匹配对象
///   - regex: 匹配规则
///   - content: 替换内容
/// - Returns: 结果
public func replace(validateString:String, regex:String, content:String) -> String {
    do {
        let RE = try NSRegularExpression(pattern: regex, options: .caseInsensitive)
        let modified = RE.stringByReplacingMatches(in: validateString, options: .reportProgress, range: NSRange(location: 0, length: validateString.count), withTemplate: content)
        return modified
    }
    catch {
        return validateString
    }
   
}


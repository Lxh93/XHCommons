//
//  MoyaCofig.swift
//  CMICPro
//
//  Created by 李小华 on 2022/11/21.
//


/// DEV 环境
var Moya_DEVUrl = "http://192.168.3.169"
/// SIT 环境
var Moya_SITUrl = "http://192.168.3.174"
/// UAT

#if DEBUG

var Moya_dynamicBaseUrl = Moya_DEVUrl
/// 辅助服务
let Moya_kSupUrl = Moya_DEVUrl
#else

var Moya_dynamicBaseUrl = Moya_DEVUrl
/// 辅助服务
let Moya_kSupUrl = Moya_DEVUrl
#endif


let ResultDefaultMsg = "网络请求错误"  //错误消息提示

enum CMServiceResponseCode : Int {
    case code200 = 200//成功
    case code400 = 400// 默认错误
    case code401 = 401// 未登录或登录失效(未登录)
    case code402 = 402// api无效
    case code403 = 403// 账户未激活（需要预存xxxUSDT）
    case code406 = 406// 欠费
    case code408 = 408// 需要仓位风险提示
    case code500 = 500// 其它错误
    case code1002 = 1002// 二级密码错误
}

//
//  API.swift
//  CMICPro
//
//  Created by 李小华 on 2022/11/21.
//


import Foundation
import Moya


enum API{
    case easyRequset
    case contractProtocols(type: Int)
    case captchaCheck(parameters:[String:Any])
    /// 上传 图片
    case uploadImage(parameters:[String:Any], data: Data)
    /// 上传 视频
    case uploadVideo(parameters:[String:Any], data: Data, name:String)
}

extension API: TargetType {
    
    var baseURL: URL {
        return URL.init(string:(Moya_dynamicBaseUrl))!
    }
    
    var path: String {
        switch self {
        case .easyRequset:
            return "www.google.com"
        default:
            return "www.baidu.com"
        }
    }

    var method: Moya.Method {
        switch self {
        case .uploadImage,
             .uploadVideo:
            return .post
        default:
            return .get
        }
    }

    enum DataClassType {
        case dictionary
        case array
        case string
    }
    var dataClassType: DataClassType? {
        switch self {
        case .contractProtocols:
            return .dictionary
        case .easyRequset:
            return .array
        default:
            return nil
        }
    }

    //    这个是做单元测试模拟的数据，必须要实现，只在单元测试文件中有作用
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }

    //    该条请API求的方式,把参数之类的传进来
    var task: Task {
        switch self {
        case .easyRequset:
            return .requestPlain
        case .captchaCheck(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
//        case .contractPay(let parameters):
//            return .requestCompositeParameters(bodyParameters: parameters,
//                                               bodyEncoding: JSONEncoding.default,
//                                               urlParameters: [:])
        case let .contractProtocols(type):
            return .requestParameters(parameters: ["type" : type], encoding: URLEncoding.queryString)
//        case let .register(email, password):
//            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
//        case .easyRequset:
//            return .requestPlain
//        case let .updateAPi(parameters):
//            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
//        //图片上传
//        case .uploadHeadImage(let parameters, let imageDate):
//            ///name 和fileName 看后台怎么说，   mineType根据文件类型上百度查对应的mineType
//            let formData = MultipartFormData(provider: .data(imageDate), name: "file",
//                                              fileName: "hangge.png", mimeType: "image/png")
//            return .uploadCompositeMultipart([formData], urlParameters: parameters)
        case .uploadImage(let parameters, let data):
            ///name 和fileName 看后台怎么说，   mineType根据文件类型上百度查对应的mineType
            let timeInterval = Date.timeIntervalSinceReferenceDate//643347865.94064999
//            let timeInterval = 64334786594064999//643347865.94064999
            let formData = MultipartFormData(provider: .data(data),
                                             name: "file",
                                             fileName: "\(String(timeInterval)).jpeg",
                                             mimeType: "image/jpeg")
            return .uploadCompositeMultipart([formData], urlParameters: parameters)
            
        case .uploadVideo(let parameters, let data, _):
            ///name 和fileName 看后台怎么说，   mineType根据文件类型上百度查对应的mineType
//            let timeInterval = Date.timeIntervalSinceReferenceDate
//            let formData = MultipartFormData(provider: .data(data),
//                                             name: "file",
//                                             fileName: "\(String(timeInterval)).mov",
//                                             mimeType: "video/quicktime")
//            let formData = MultipartFormData(provider: .data(data),
//                                             name: "file",
//                                             fileName: name,
//                                             mimeType: "video/mp4")
            
            let timeInterval = Date.timeIntervalSinceReferenceDate
            let formData = MultipartFormData(provider: .data(data),
                                             name: "file",
                                             fileName: "\(String(timeInterval)).mp4",
                                             mimeType: "video/mp4")
            //video/mp
            return .uploadCompositeMultipart([formData], urlParameters: parameters)
            
        }
        //可选参数https://github.com/Moya/Moya/blob/master/docs_CN/Examples/OptionalParameters.md
//        case .users(let limit):
//        var params: [String: Any] = [:]
//        params["limit"] = limit
//        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        //           var version = ""
        //           if let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        //               version = v
        //           }
        //        Content-Type: application/json; charset=UTF-8
        //            "Accept": "*/*",
        var headers = [
            "Content-type": "application/json",
            "Accept": "application/json",
            "source" : "ios",
            "systemVersion" : UIDevice.current.systemVersion,
        ]
        return headers
    }
}

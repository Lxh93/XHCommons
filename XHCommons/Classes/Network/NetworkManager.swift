//
//  NetworkManager.swift
//  CMICPro
//
//  Created by 李小华 on 2022/11/21.
//

import Moya
import PKHUD
import Alamofire

/// 超时时长
private var requestTimeOut: Double = 30
/// 成功数据的回调
typealias successCallback = ((Any?) -> Void)
/// 失败的回调
typealias failedCallback = ((String, Any?) -> Void)
/// 网络错误的回调
typealias errorCallback = ((Int) -> Void)

/// 网络请求的基本设置,这里可以拿到是具体的哪个网络请求，可以在这里做一些设置
private let myEndpointClosure = { (target: TargetType) -> Endpoint in
    /// 这里把endpoint重新构造一遍主要为了解决网络请求地址里面含有? 时无法解析的bug https://github.com/Moya/Moya/issues/1198
    let url = target.baseURL.absoluteString + target.path
    var task = target.task
    
    
    //     如果需要在每个请求中都添加类似token参数的参数请取消注释下面代码
    //     👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇
    
    var additionalParameters : [String : Any] = [:]
//    var additionalParameters = ["uuid":"11111111"]
//    if UserManager.shared.logined {
//        additionalParameters["uuid"] = UserManager.shared.userModel?.uuid
//    }
//    if kTestUUID {
//        additionalParameters["uuid"] = "11$A33CD706398145A8AA56FE94F20063F3"
//    }
//    if kNewPortTest {
//        additionalParameters = [:]
//    }
    let defaultEncoding = URLEncoding.default
    switch target.task {
    ///在你需要添加的请求方式中做修改就行，不用的case 可以删掉。。
    case .requestPlain:
        task = .requestParameters(parameters: additionalParameters, encoding: defaultEncoding)
    case .requestParameters(var parameters, let encoding):
        additionalParameters.forEach { parameters[$0.key] = $0.value }
        task = .requestParameters(parameters: parameters, encoding: encoding)
    case var .requestCompositeParameters(bodyParameters, bodyEncoding, urlParameters):
        additionalParameters.forEach { bodyParameters[$0.key] = $0.value }
        task = .requestCompositeParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding, urlParameters: urlParameters)
    case .uploadCompositeMultipart(let multipart, var urlParameters):
        additionalParameters.forEach { urlParameters[$0.key] = $0.value }
        task = .uploadCompositeMultipart(multipart, urlParameters: urlParameters)
    default:
        break
    }
    //     👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆
    //     如果需要在每个请求中都添加类似token参数的参数请取消注释上面代码
    
    
    
    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: task,
        httpHeaderFields: target.headers
    )
    requestTimeOut = 30 // 每次请求都会调用endpointClosure 到这里设置超时时长 也可单独每个接口设置
    // 针对于某个具体的业务模块来做接口配置
    //    if let apiTarget = target as? API {
    //        switch apiTarget {
    //        case .easyRequset:
    //            return endpoint
    //        case .register:
    //            requestTimeOut = 5
    //            return endpoint
    //
    //        default:
    //            return endpoint
    //        }
    //    }
    
    return endpoint
}

/// 网络请求的设置
private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        // 设置请求时长
        request.timeoutInterval = requestTimeOut
        // 打印请求参数
        if let requestData = request.httpBody {
            print("\(request.url!)" + "\n" + "\(request.httpMethod ?? "")" + "发送参数" + "\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
        } else {
            print("\(request.url!)" + "\(String(describing: request.httpMethod))")
        }
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

/*   设置ssl
 let policies: [String: ServerTrustPolicy] = [
 "example.com": .pinPublicKeys(
 publicKeys: ServerTrustPolicy.publicKeysInBundle(),
 validateCertificateChain: true,
 validateHost: true
 )
 ]
 */

// 用Moya默认的Manager还是Alamofire的Manager看实际需求。HTTPS就要手动实现Manager了
// private public func defaultAlamofireManager() -> Manager {
//
//    let configuration = URLSessionConfiguration.default
//
//    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
//
//    let policies: [String: ServerTrustPolicy] = [
//        "ap.grtstar.cn": .disableEvaluation
//    ]
//    let manager = Alamofire.SessionManager(configuration: configuration,serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
//
//    manager.startRequestsImmediately = false
//
//    return manager
// }

/// NetworkActivityPlugin插件用来监听网络请求，界面上做相应的展示
/// 但这里我没怎么用这个。。。 loading的逻辑直接放在网络处理里面了
private let networkPlugin = NetworkActivityPlugin.init { changeType, _ in
    print("networkPlugin \(changeType)")
    // targetType 是当前请求的基本信息
    switch changeType {
    case .began:
        print("开始请求网络")
        
    case .ended:
        print("结束")
    }
}

// https://github.com/Moya/Moya/blob/master/docs/Providers.md  参数使用说明
// stubClosure   用来延时发送网络请求

/// /网络请求发送的核心初始化方法，创建网络请求对象
let Provider = MoyaProvider<MultiTarget>(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)

/// 最常用的网络请求，只需知道正确的结果无需其他操作时候用这个 (可以给调用的NetWorkReques方法的写参数默认值达到一样的效果,这里为解释方便做抽出来二次封装)
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 请求成功的回调
func NetWorkRequest(_ target: TargetType, completion: @escaping successCallback) {
    NetWorkRequest(target, completion: completion, failed: nil, errorResult: nil)
}

/// 最常用的网络请求，只需知道正确的结果无需其他操作时候用这个 (可以给调用的NetWorkReques方法的写参数默认值达到一样的效果,这里为解释方便做抽出来二次封装)
///
/// - Parameters:
///   - needHUD: 需要hud吗
///   - needAllResult: 需要completion返回所有的model数据 ， 而不只是model.data
///   - target: 网络请求
///   - completion: 请求成功的回调
func NetWorkRequest(_ needHUD:Bool, fullResult:Bool = false, _ target: TargetType, completion: @escaping successCallback, failed: failedCallback? = nil, errorResult: errorCallback? = nil) {

    let hud = HUD()
    if needHUD {
        hud.show(onView: UIViewController.jk.topViewController()?.view)
//        hud.show(onView: getLastWindow())
    }
    NetWorkRequest(target, fullResult, completion: { dic in
        hud.hide()
        completion(dic)
    }, failed: { text, context in
        hud.hide()
        if let failedBlock = failed {
            failedBlock(text, context)
        }
    }) {code in
        hud.hide()
        if let errorResult = errorResult {
            errorResult(code)
        }
    }
}

func NetWorkRequest(windowHUD:Bool, fullResult:Bool = false, _ target: TargetType, completion: @escaping successCallback, failed: failedCallback? = nil, errorResult: errorCallback? = nil) {

    let hud = HUD()
    if windowHUD {
        hud.show(onView: getLastWindow())
    }
    NetWorkRequest(target, fullResult, completion: { dic in
        hud.hide()
        completion(dic)
    }, failed: { text, context in
        hud.hide()
        if let failedBlock = failed {
            failedBlock(text, context)
        }
    }) {code in
        hud.hide()
        if let errorResult = errorResult {
            errorResult(code)
        }
    }
}

/// 需要知道成功或者失败的网络请求， 要知道code码为其他情况时候用这个 (可以给调用的NetWorkRequest方法的参数默认值达到一样的效果,这里为解释方便做抽出来二次封装)
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 成功的回调
///   - failed: 请求失败的回调
func NetWorkRequest(_ target: TargetType, completion: @escaping successCallback, failed: failedCallback?) {
    NetWorkRequest(target, completion: completion, failed: failed, errorResult: nil)
}

///  需要知道成功、失败、错误情况回调的网络请求   像结束下拉刷新各种情况都要判断
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 成功
///   - failed: 失败
///   - error: 错误
@discardableResult // 当我们需要主动取消网络请求的时候可以用返回值Cancellable, 一般不用的话做忽略处理
func NetWorkRequest(_ target: TargetType, _ fullResult:Bool = false, completion: @escaping successCallback, failed: failedCallback?, errorResult: errorCallback?) -> Cancellable? {
    // 先判断网络是否有链接 没有的话直接返回--代码略
    if !UIDevice.isNetworkConnect {
        //        print("提示用户网络似乎出现了问题")
        showText("请检查您的网络")
        errorResult?(10001)
        return nil
    }
    
    // 这里显示loading图
    return Provider.request(MultiTarget(target)) { result in
        // 隐藏hud
        switch result {
        case let .success(response):
            do {
                //过滤成功的状态码响应
                _ = try response.filterSuccessfulStatusCodes()
                _ = try JSON(response.mapJSON())
//                let json = try JSON(response.mapJSON())
                
                guard let jsonString = String(data: response.data, encoding: String.Encoding.utf8) else {
                    showErrorMsgText("json映射失败")
                    failed?("json映射失败", nil)
                    return
                }
                guard let model = FirstModel.deserialize(from: jsonString) else {
                    showErrorMsgText("FirstModel生成失败")
                    failed?("FirstModel生成失败", nil)
                    return
                }
                if model.code != CMServiceResponseCode.code200.rawValue {
                    
                    let msg = model.message ?? ResultDefaultMsg
                    if model.code == CMServiceResponseCode.code408.rawValue {
                        failed?(msg, model)
                        return
                    }
                    
                    if model.code == CMServiceResponseCode.code401.rawValue {
//                        UserManager.shared.clear()
//                        checkAndLogin(completionBlock: nil)
                    }
                    
                    showText(msg)
                    failed?(msg, model)
                    return
                }
                
                if let apiTarget =  target as? API, let dataClassType = apiTarget.dataClassType  {
               
                    switch dataClassType {
                    case .dictionary:
                        guard model.data is [String : Any] else {
                            showErrorMsgText("数据不是字典类型")
                            failed?("数据不是字典类型", model)
                            return
                        }
                    case .array:
                        guard model.data is [Any] else {
                            showErrorMsgText("数据不是数组类型")
                            failed?("数据不是数组类型", model)
                            return
                        }
                    case .string:
                        guard model.data is String else {
                            showErrorMsgText("数据不是字符串类型")
                            failed?("数据不是字符串类型", model)

                            return
                        }
                    }
                }

                if fullResult {
                    completion(model)
                } else {
                    completion(model.data)
                }
                
                
                
            } catch MoyaError.statusCode(let errorResponse) {
                let statusCode = errorResponse.statusCode
                showErrorMsgText("网络请求失败Code：" + String(statusCode))
                errorResult?(statusCode)
            } catch MoyaError.jsonMapping(_) {
                showErrorMsgText("json映射失败")
                failed?("json映射失败", nil)
            } catch let error {
                showErrorMsgText("网络请求错误")
                //如果数据获取失败，则返回错误状态码
                errorResult?((error as! MoyaError).response!.statusCode)
            }
        case let .failure(error):
            showErrorMsgText(error.errorDescription ?? "网络请求错误")
            //失败的情况。这里的失败指的是服务器没有收到请求（例如可达性/连接性错误）或者没有发送响应（例如请求超时）。我们可以在这里设置个延迟请求，过段时间重新发送请求。
            switch error {
            case .underlying(let error1, let response):
                print("错误原因：\(error.errorDescription ?? "")")
                print(error1)
                print(response as Any)
                errorResult?(10000)//请求超时返回10000
            default:
                print("错误原因：\(error.errorDescription ?? "")")
                errorResult?(0)
            }
            
        }
    }
}

func showErrorMsgText (_ text: String) {
    #if DEBUG
    showText(text)
    #else
    showText(ResultDefaultMsg)
    #endif
}

/**
 有同学问可否把数据转模型也封装到网络请求中  下面的方法是大概的实现思路，仅供参考↓↓↓↓↓↓↓↓↓↓↓↓
 */

//// 成功回调
//typealias RequestSuccessCallback = ((_ model: Any?, _ message: String?, _ resposneStr: String) -> Void)
//// 失败回调
//typealias RequestFailureCallback = ((_ code: Int?, _ message: String?) -> Void)
//
///// 带有模型转化的底层网络请求的基础方法    可与 179 行核心网络请求方法项目替换 唯一不同点是把数据转模型封装到了网络请求基类中
/////  本方法只写了大概数据转模型的实现，具体逻辑根据业务实现。
///// - Parameters:
/////   - target: 网络请求接口
/////   - isHideFailAlert: 是否隐藏失败的弹框
/////   - modelType: 数据转模型所需要的模型
/////   - successCallback: 网络请求成功的回调 转好的模型返回出来
/////   - failureCallback: 网络请求失败的回调
///// - Returns: 可取消网络请求的实例
//@discardableResult
//func NetWorkRequest<T: Mappable>(_ target: TargetType, isHideFailAlert: Bool = false, modelType: T.Type?, successCallback: RequestSuccessCallback?, failureCallback: RequestFailureCallback? = nil) -> Cancellable? {
//    // 这里显示loading图
//    return Provider.request(MultiTarget(target)) { result in
//        // 隐藏hud
//        switch result {
//        case let .success(response):
//            do {
//                let jsonData = try JSON(data: response.data)
//                // data里面不返回数据 只是简单的网络请求 无需转模型
//                if jsonData["data"].dictionaryObject == nil, jsonData["data"].arrayObject == nil { // 返回字符串
//                    successCallback?(jsonData["data"].string, jsonData["message"].stringValue, String(data: response.data, encoding: String.Encoding.utf8)!)
//                    return
//                }
//
//                if jsonData["data"].dictionaryObject != nil { // 字典转model
//                    if let model = T(JSONString: jsonData["data"].rawString() ?? "") {
//                        successCallback?(model, jsonData["message"].stringValue, String(data: response.data, encoding: String.Encoding.utf8)!)
//                    } else {
//                        failureCallback?(jsonData["data"].intValue, "解析失败")
//                    }
//                } else if jsonData["data"].arrayObject != nil { // 数组转model
//                    if let model = [T](JSONString: jsonData["data"].rawString() ?? "") {
//                        successCallback?(model, jsonData["message"].stringValue, String(data: response.data, encoding: String.Encoding.utf8)!)
//                    } else {
//                        failureCallback?(jsonData["data"].intValue, "解析失败")
//                    }
//                }
//            } catch {}
//        case let .failure(error):
//            // 网络连接失败，提示用户
//            print("网络连接失败\(error)")
//            failureCallback?(nil, "网络连接失败")
//        }
//    }
//}

/// 基于Alamofire,网络是否连接，，这个方法不建议放到这个类中,可以放在全局的工具类中判断网络链接情况
/// 用计算型属性是因为这样才会在获取isNetworkConnect时实时判断网络链接请求，如有更好的方法可以fork
extension UIDevice {
    static var isNetworkConnect: Bool {
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true // 无返回就默认网络已连接
    }
}

//
//  APIService.swift
//  ThiqahDelivery
//
//  Created by Gaurav Prakash on 15/08/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import Alamofire

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    }
    catch{
        return data // fallback to original data if it can't be serialized.
    }
}

let configuration = { () -> URLSessionConfiguration in
    let config = URLSessionConfiguration.default
    config.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
    config.timeoutIntervalForRequest = 200 // as seconds, you can set your request timeout
    config.timeoutIntervalForResource = 400 // as seconds, you can set your resource timeout
    config.requestCachePolicy = .useProtocolCachePolicy
    return config
}()

let manager = Manager(
    configuration: configuration,
    serverTrustPolicyManager: CustomServerTrustPoliceManager()
)

let ThiqahAPIProvider = MoyaProvider<Thiqah>(manager: manager,plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              )

// MARK: - Provider support

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum Thiqah {
    case REGISTER([String: Any])
    case LOGIN([String:Any])
    case DRIVERORDERS([String:Any])
    case DELIVEREDSTATUS([String:Any])
    case UNDELIVEREDSTATUS([String:Any])
    
}

extension Thiqah: TargetType {
    public var task: Task {
        switch self {
        case .REGISTER(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .LOGIN(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .DRIVERORDERS(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .DELIVEREDSTATUS(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .UNDELIVEREDSTATUS(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
        
        
    }
    
    public var headers: [String : String]? {
        return [:]
    }
    public var baseURL: URL { return URL(string: thiqahApi)! }
    
    public var path: String {
        switch self {
        case .REGISTER:
            return "driver_new"
        case .LOGIN:
            return "driver_login"
        case .DRIVERORDERS:
            return "driver_orders"
        case .DELIVEREDSTATUS:
            return "delivered_status"
        case .UNDELIVEREDSTATUS:
            return "undelivered_status"
        }
    }
    public var method: Moya.Method {
        return .post
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    public var validate: Bool {
        switch self {
        default:
            return false
        }
    }
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

//MARK: - Response Handlers

extension Moya.Response {
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}

class CustomServerTrustPoliceManager : ServerTrustPolicyManager {
    override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        return .disableEvaluation
    }
    public init() {
        super.init(policies: [:])
    }
}

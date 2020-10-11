//
//  NetworkTarget.swift
//  Network
//
//  Created by hacoma on 2020/10/11.
//

import Moya

public protocol NetworkTarget {
    
    var baseURL: URL { get }
    var path: String { get }
    var method: Method { get }
    var sampleData: Data { get }
    var task: Task { get }
    var headers: [String: String]? { get }
}

public enum Method: String {
    
    case get
    case post
    case put
    case delete
    
    var toMoya: Moya.Method {
        let uppercased = rawValue.uppercased()
        return Moya.Method(rawValue: uppercased)
    }
}

public enum Task {
    
    case requestPlain
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
    
    var toMoya: Moya.Task  {
        switch self {
        case .requestPlain:
            return Moya.Task.requestPlain
        case .requestParameters(let parameters, let encoding):
            return Moya.Task.requestParameters(parameters: parameters, encoding: encoding.toMoya)
        }
    }
}

public protocol ParameterEncoding {
    
    var toMoya: Moya.ParameterEncoding { get }
}

public enum URLEncoding: ParameterEncoding {
    
    case `default`
    case queryString
    
    public var toMoya: Moya.ParameterEncoding {
        
        switch self {
        case .default:
            return Moya.URLEncoding.default
        case .queryString:
            return Moya.URLEncoding.queryString
        }
    }
}

public enum JSONEncoding: ParameterEncoding {
    
    case `default`
    case prettyPrinted
    
    public var toMoya: Moya.ParameterEncoding {
        switch self {
        case .default:
            return Moya.JSONEncoding.default
        case .prettyPrinted:
            return Moya.JSONEncoding.prettyPrinted
        }
    }
}

public extension NetworkTarget {
    
    var headers: [String: String]? {
        guard let userAgent = Network.userAgent else { return nil }
        return ["User-Agent": userAgent()]
    }
}

struct MoyaNetworkTarget: Moya.TargetType {
    
    let baseURL: URL
    let path: String
    let method: Moya.Method
    let sampleData: Data
    let task: Moya.Task
    let headers: [String : String]?
    
    init(target: NetworkTarget) {
        baseURL = target.baseURL
        path = target.path
        method = target.method.toMoya
        sampleData = target.sampleData
        task = target.task.toMoya
        headers = target.headers
    }
}

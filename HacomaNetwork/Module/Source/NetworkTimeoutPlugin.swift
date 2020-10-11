//
//  NetworkTimeoutPlugin.swift
//  Network
//
//  Created by hacoma on 2020/10/11.
//

import Moya

final class NetworkTimeoutPlugin: PluginType {
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.timeoutInterval = Network.timeoutInterval
        return request
    }
}

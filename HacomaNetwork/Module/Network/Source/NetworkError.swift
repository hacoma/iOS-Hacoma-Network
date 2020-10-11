//
//  NetworkError.swift
//  Network
//
//  Created by hacoma on 2020/10/11.
//

public enum NetworkError: Swift.Error {
    
    case jsonMapping(NetworkResponse)
    case statusCode(NetworkResponse)
    case requestMapping(String)
    case parameterEncoding(Swift.Error)
    case unknown
}

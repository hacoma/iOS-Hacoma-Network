//
//  NetworkProvider.swift
//  Network
//
//  Created by hacoma on 2020/10/11.
//

import Moya

public final class NetworkProvider<Target: NetworkTarget> {
    
    public typealias Completion = (Result<NetworkResponse, NetworkError>) -> Void
    
    private var cancellables: [Cancellable] = []
    
    public init() {
        // available outside of the framework
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    public func request(target: Target, completion: @escaping Completion) {
        let plugins = createPlugins(target: target)
        let provider = Provider<Target>(plugins: plugins)
        let moyaTarget = MoyaNetworkTarget(target: target)
        
        let cancellable = provider.request(moyaTarget) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let moyaResponse):
                let response = self.createResponse(response: moyaResponse)
                completion(.success(response))
            case .failure(let moyaError):
                let error = self.createError(error: moyaError)
                completion(.failure(error))
            }
        }
        
        addCancellable(target: target, cancellable: cancellable)
    }
    
    public func cancel(target: Target) {
        cancelCancellables(target: target)
        removeCancellables(target: target)
    }
}

extension NetworkProvider {
    
    private func createPlugins(target: Target) -> [PluginType] {
        let timeoutPlugin = NetworkTimeoutPlugin(timeoutInterval: target.timeoutInterval)
        return [timeoutPlugin]
    }
}

extension NetworkProvider {
    
    private func createResponse(response: Moya.Response) -> NetworkResponse {
        return NetworkResponse(statusCode: response.statusCode, data: response.data)
    }
    
    private func createError(error: Moya.MoyaError) -> NetworkError {
        switch error {
        case .jsonMapping(let moyaResponse):
            let response = createResponse(response: moyaResponse)
            return .jsonMapping(response)
        case .statusCode(let moyaResponse):
            let response = createResponse(response: moyaResponse)
            return .statusCode(response)
        case .requestMapping(let string):
            return .requestMapping(string)
        case .parameterEncoding(let error):
            return .parameterEncoding(error)
        default:
            return .unknown
        }
    }
}

extension NetworkProvider {
    
    private struct Cancellable {
        let key: String
        let cancellable: Moya.Cancellable
    }
    
    private func addCancellable(target: Target, cancellable: Moya.Cancellable) {
        let key = createCancellableKey(target: target)
        let cancellable = Cancellable(key: key, cancellable: cancellable)
        cancellables.append(cancellable)
    }
    
    private func removeCancellables(target: Target) {
        let key = createCancellableKey(target: target)
        cancellables.removeAll { $0.key == key }
    }
    
    private func cancelCancellables(target: Target) {
        let key = createCancellableKey(target: target)
        cancellables
            .filter { $0.key == key }
            .map { $0.cancellable }
            .forEach { $0.cancel() }
    }
    
    private func createCancellableKey(target: Target) -> String {
        return target.baseURL.absoluteString + target.path + target.method.rawValue
    }
}

private final class Provider<Target: NetworkTarget>: MoyaProvider<MoyaNetworkTarget> {
    
    init(plugins: [PluginType] = []) {
        super.init(plugins: plugins)
    }
}

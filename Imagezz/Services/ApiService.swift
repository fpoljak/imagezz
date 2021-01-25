//
//  ApiService.swift
//  Imagezz
//
//  Created by Frane Poljak on 25/01/2021.
//  Copyright © 2021 fpoljak. All rights reserved.
//

import Foundation
import Alamofire

public class ApiService {
    static var baseUrl: String {
        get {
            if ProcessInfo.processInfo.arguments.contains("TESTING") {
                return "http://localhost:8080/"
            } else {
                return "https://picsum.photos/v2/"
            }
        }
    }
    
    private static var sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = TimeInterval(10)
        configuration.timeoutIntervalForRequest = TimeInterval(10)
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData

        return Session.init(configuration: configuration)
    }()
    
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }()
    
    static private func getHeaders() -> HTTPHeaders {
        var _headers = HTTPHeaders()
        _headers["Content-Type"] = "Application/json"
        _headers["Accept"] = "Application/json"
        
        return _headers
    }
    
    @discardableResult
    static func genericRequest<T: Codable>(method: HTTPMethod, endpoint: String, params: [String: Any]? = nil, completion: @escaping ((T?) -> Void)) -> DataRequest {
        
        let fullUrl = baseUrl + endpoint
        print("URL: \(fullUrl)")
        print("Params: \(params ?? [:])")
        let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
        
        let request = sessionManager.request(fullUrl, method: method, parameters: params, encoding: encoding, headers: getHeaders())
        
        request.responseDecodable(of: T.self, decoder: decoder) { (response: DataResponse<T, AFError>) in
            if let error = response.error {
                let nsError = error.underlyingError as NSError?
                if nsError?.code == -999 { // cancelled
                    return
                }
//                errorHandler(error)
                defaultErrorHandler(error)
                return
            }
            if let value = response.value as T? {
                completion(value)
                return
            }
            completion(nil)
        }
            
        return request
    }
    
    static let defaultErrorHandler = {(error: Error) in
        let error = error as NSError
        let domain = error.domain
        let message = error.localizedDescription
        print("Api error: ", domain, ": ", message)
    }
}

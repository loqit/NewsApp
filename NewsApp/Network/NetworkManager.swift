//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Андрей Бобр on 25.12.20.
//

import Foundation
import Alamofire

class NetworkManager {
    
    private let baseUrl = NetworkConstants.baseUrl
        
    var headers: HTTPHeaders? {
        var allHeaders = HTTPHeaders([])
        guard let dict = Bundle.plistRootDictionary(filename: "APIInfo"),
              let apiKey = dict["apiKey"] as? String else {
            return nil
        }
        allHeaders.add(HTTPHeader(name: "X-Api-Key", value: apiKey))
        return allHeaders
    }
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func get<T: Codable>(path: NetworkConstants,
                         params: [String: Any],
                         completion: @escaping (Result<T, NetworkError>) -> Void) {
        self.request(method: .get, path: path, params: params, completion: completion)
    }
    
    func post<T: Codable>(path: NetworkConstants,
              params: [String: Any],
              completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        self.request(method: .post, path: path, params: params, completion: completion)
        
    }
    
    private func request<T: Codable>(method: HTTPMethod,
                         path: NetworkConstants,
                         params: [String: Any],
                         encoding: ParameterEncoding = URLEncoding.default,
                         completion: @escaping (Result<T, NetworkError>) -> Void) -> DataRequest{
        
        let pathString = baseUrl.rawValue + path.rawValue
        print(params)
        let request = {
            return AF.request(pathString,
                              method: method,
                              parameters: params,
                              encoding: encoding,
                              headers: self.headers)
        }
        
        return request().validate().responseDecodable(of: T.self) { response in
            if let error = response.error {
                print(error)
                completion(.failure(.unableToComplite))
                return
            }
            if let data = response.data {
                let decoder = JSONDecoder()
                if let object = try? decoder.decode(T.self, from: data) {
                    completion(.success(object))
                    return
                } else {
                    completion(.failure(.inavlidData))
                    return
                }
                
            }
        }
    }
    
    
    func newJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }

    func newJSONEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            encoder.dateEncodingStrategy = .iso8601
        }
        return encoder
    }


}
// MARK: - Alamofire response handlers

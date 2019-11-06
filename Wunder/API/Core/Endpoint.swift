//
//  Endpoint.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import Foundation
import RxSwift

protocol EndpointProtocol {
    
    associatedtype Input
    associatedtype Output: Decodable
    associatedtype Error: EndpointErrorProtocol
    
    static var path: (Input) -> String { get }
    static var headers: (Input) -> [String: String] { get }
    
    associatedtype Method: EndpointMethodProtocol where Method.Input == Input
    static var method: Method { get }
}

extension EndpointProtocol {
    
    typealias Task = Observable<Result<Output, APIError<Error>>>
    typealias Apply = (Input) -> Task
    
    static func make(with session: URLSession) -> Apply {
        return make(with: session, encoder: JSONEncoder.default, decoder: JSONDecoder.default)
    }
    
    static func make(with session: URLSession, encoder: EncoderProtocol, decoder: DecoderProtocol) -> Apply {
        return { input in
            let path = self.path(input)
            let headers = self.headers(input)
            let method = self.method
            
            guard let url = URL(string: path) else {
                return Observable.just(.failure(.invalid(path: path)))
            }
            
            func makeRequest() throws -> URLRequest {
                var request = URLRequest(url: url)
                request.allHTTPHeaderFields = headers
                
                let methodData = try method.encode(input: input, using: encoder)
                request.httpMethod = methodData.httpMethod
                
                switch methodData {
                case .get: break
                case let .post(body): request.httpBody = body
                }
                
                return request
            }
            
            return Observable.create { subscriber in
                
                do {
                    
                    let request = try makeRequest()
                
                    let task = session.dataTask(with: request) { data, response, error in
                        
                        defer { subscriber.onCompleted() }
                        
                        guard let data = data else {
                            subscriber.onNext(.failure(.parse(code: response?.code)))
                            return
                        }
                        
                        do {
                            let output = try decoder.decode(Output.self, from: data)
                            subscriber.onNext(.success(output))
                        } catch {
                            subscriber.onNext(.failure(.codable(error: error)))
                        }
                    }
                    
                    task.resume()
                    
                    return Disposables.create(with: task.cancel)
                    
                } catch {
                    subscriber.onNext(.failure(.codable(error: error)))
                    subscriber.onCompleted()
                }
                return Disposables.create()
            }
        }
    }
}

private extension URLResponse {
    
    var code: Int? {
        return (self as? HTTPURLResponse)?.code
    }
}

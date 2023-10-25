//
//  PyonsnalColorClient.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/03.
//

import Foundation
import Combine
import Alamofire

typealias ResponsePublisher<T: Decodable> = AnyPublisher<DataResponse<T, NetworkError>, Never>

final class PyonsnalColorClient: NetworkRequestable {
    // MARK: - Private Property
    private let decoder = JSONDecoder()
    
    // MARK: - Initializer
    init() {}
    
    // MARK: - Interface
    func request<T: Decodable>(
        _ urlRequest: NetworkRequestBuilder,
        model: T.Type
    ) -> ResponsePublisher<T> {
        if let curlString = urlRequest.urlRequest?.curlString {
            Log.n(message: "Request curl: \(curlString)")
        } else {
            Log.n(message: "Request curl: nil")
        }
        return AF.request(urlRequest)
            .publishDecodable(type: T.self)
            .map { response in
                response.mapError { _ in
                    if let curlString = response.request?.curlString {
                        Log.n(message: "Request curl: \(curlString)")
                    } else {
                        Log.n(message: "Request curl: nil")
                    }
                    guard let responseData = response.data else {
                        Log.n(message: "\(response.error)")
                        return NetworkError.emptyResponse
                    }
                    let responseError = try? self.decoder.decode(ErrorResponse.self, from: responseData)
                    if let responseError {
                        Log.n(message: "\(responseError)")
                        return NetworkError.response(responseError)
                    } else if let responseDataString = String(data: responseData, encoding: .utf8) {
                        Log.n(message: "Response Body: \(responseDataString)")
                        return NetworkError.response(.init(code: nil, message: nil, bodyString: responseDataString))
                    }
                    return NetworkError.unknown
                
                }
            }.eraseToAnyPublisher()
    }
}

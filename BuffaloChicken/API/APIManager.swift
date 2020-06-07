//
//  APIManager.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/11/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit

public typealias ResultCallback<Value> = (Result<Value, Error>) -> Void

public enum ResponseError: Error {
    case encoding
    case decoding
    case server(message: String)
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public class APIManager {
    
    public static func request<Request:GoogleRequest, Response:GoogleResponse>(_ httpMethod: HTTPMethod? = .get, request: Request, responseType: Response.Type, headers: [String:String]? = nil, dispatchGroup: DispatchGroup? = nil, completion: @escaping ResultCallback<Response>) {
        
        if let _dispatchGroup = dispatchGroup {
            _dispatchGroup.enter()
        }
        
        guard let _url = request.url else { return }
        
        var urlRequest = URLRequest(url: _url)
        urlRequest.httpMethod = httpMethod?.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let headers = headers {
            for header in headers {
                urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10.0
        sessionConfig.timeoutIntervalForResource = 10.0
        
        URLSession(configuration: sessionConfig).dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                //If there is data attempt to decode
                if let data = data {
                    //Attempt to decode response as a JSON Object
                    if let decodedModel: Response = try? JSONDecoder().decode(Response.self, from: data), let status = decodedModel.status {
                        if status.contains("200") || status.contains("OK") {
                            completion(.success(decodedModel))
                        } else {
                            completion(.failure(GoogleError(status: status)))
                        }
                    //Attempt to decode response as an image
                    } else if let photoResponse = PhotoResponse(data: data) as? Response {
                        completion(.success(photoResponse))
                    //Decoding failed
                    } else {
                        completion(.failure(GoogleError(type: .decoding)))
                    }
                } else if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(GoogleError(type: .unknown)))
                }
                if let _dispatchGroup = dispatchGroup {
                    _dispatchGroup.leave()
                }
            }
        }.resume()
    }
    
    //    func getReviewsRequest(placeID: String, response: @escaping ([Review]?, Error?) -> Void) {
    //        if let url = URL(string: "https://samdoggett.com/WingsNearMe/get_reviews.php") {
    //            var request = URLRequest(url: url)
    //            let postString = ("PlaceID="+placeID).data(using: .utf8)
    //            request.httpBody = postString
    //
    //            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
    //                guard error == nil else {
    //                    response(nil, error)
    //                    return
    //                }
    //                if let data = data, let response = try? JSONDecoder().decode(DetailResponse.self, from: data), let result = response.result {
    //                    response(result, nil)
    //                }
    //            })
    //            task.resume()
    //        }
    //    }
}

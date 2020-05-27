//
//  APIManager.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/11/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import Foundation

public typealias ResultCallback<Value> = (Result<Value, Error>) -> Void

let api_key = "AIzaSyDnfkzsqLDaN8gBW5uHqq4hOS6JJJElgUo"

public class APIManager {
    
    func placesRequest(search_term: String, lat: Double, long: Double, radius: Double = 10000, testing: Bool = false, completion: @escaping ResultCallback<[Place]>) {
        var url: URL?
        if !testing {
            let query = search_term.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&radius=\(radius)&type=food&keyword=\(query)&key=\(api_key)")
        } else {
            url = URL(string: "https://samdoggett.com/WingsNearMe/NearbySearch.json")
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url!), completionHandler: { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(PlacesResponse.self, from: data)
                    
                    if let results = response.results {
                        completion(.success(results))
                    } else if let message = response.status {
                        completion(.failure(ResponseError.server(message: message)))
                    } else {
                        completion(.failure(ResponseError.decoding))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }).resume()
    }
    
    func placeDetailRequest(placeId: String, testing: Bool = false, completion: @escaping ResultCallback<PlaceDetail>) {
        var url: URL?
        if !testing {
            url = URL(string: "https://maps.googleapis.com/maps/api/place/details/json?place_id=\(placeId)&fields=formatted_address,formatted_phone_number,opening_hours/weekday_text,website&key=\(api_key)")
        } else {
            url = URL(string: "https://samdoggett.com/WingsNearMe/TestResponses/\(placeId).json")
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url!), completionHandler: { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(DetailResponse.self, from: data)
                    
                    if let result = response.result {
                        completion(.success(result))
                    } else if let message = response.status {
                        completion(.failure(ResponseError.server(message: message)))
                    } else {
                        completion(.failure(ResponseError.decoding))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }).resume()
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

public enum ResponseError: Error {
    case encoding
    case decoding
    case server(message: String)
}

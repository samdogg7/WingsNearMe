//
//  APIManager.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 5/11/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import Foundation

let api_key = "AIzaSyDnfkzsqLDaN8gBW5uHqq4hOS6JJJElgUo"

//Google maps API key for Postman: AIzaSyDnfkzsqLDaN8gBW5uHqq4hOS6JJJElgUo
//The following example is a search request for places of type 'restaurant' within a 1500m radius of a point in Hamilton, MA, containing the word 'buffalo chicken':
//https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=42.627392,-70.860649&radius=10000&type=food&keyword=wings&key=AIzaSyDnfkzsqLDaN8gBW5uHqq4hOS6JJJElgUo
//Text search https://maps.googleapis.com/maps/api/place/textsearch/json?query=123+main+street&location=42.3675294,-71.186966&radius=10000&key=YOUR_API_KEY
//YOUR_API_KEY

//rankby=distance : if let url = URL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(query)&location=\(lat),\(long)&rankby=distance&type=food,restaurant&key=\(api_key)") {


public class APIManager {
    
    func placesRequest(search_term: String, lat: Double, long: Double, radius: Double = 10000, testing: Bool = false, placesResponse: @escaping ([Place]?, Error?) -> Void) {
        if !testing {
            let query = search_term.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            if let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&radius=\(radius)&type=food&keyword=\(query)&key=\(api_key)") {
                let task = URLSession.shared.dataTask(with: URLRequest(url: url) as URLRequest, completionHandler: { data, response, error in
                    guard error == nil else {
                        placesResponse(nil, error)
                        return
                    }
                    if let data = data, let response = try? JSONDecoder().decode(PlacesResponse.self, from: data), var results = response.results {
                        //Now retrieve the place details from each place in results
                        DispatchQueue.main.async {
                            for i in 0..<results.count {
                                self.placeDetailRequest(placeId: (results[i].placeID ?? ""), testing: testing, detailResponse: { response, error in
                                    if error != nil {
                                        print(error?.localizedDescription ?? "Error")
                                        return
                                    }
                                    
                                    if let detail = response {
                                        DispatchQueue.main.async {
                                            results[i].placeDetail = detail
                                            if i == (results.count - 1) {
                                                placesResponse(results, nil)
                                            }
                                        }
                                    } else {
                                        print("Detail missing from PID: " + (results[i].placeID ?? "nil"))
                                    }
                                })
                            }
                        }
                    }
                })
                task.resume()
                
            }
        } else {
            if let path = Bundle.main.path(forResource: "NearbySearch", ofType: "json", inDirectory: "TestResponses") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    if let response = try? JSONDecoder().decode(PlacesResponse.self, from: data), let results = response.results {
                        placesResponse(results, nil)
                    }
                } catch {
                    placesResponse(nil, error)
                }
            }
        }
    }
    
    func placeDetailRequest(placeId: String, testing: Bool = false, detailResponse: @escaping (PlaceDetail?, Error?) -> Void) {
        if !testing {
            if let url = URL(string: "https://maps.googleapis.com/maps/api/place/details/json?place_id=\(placeId)&fields=formatted_address,formatted_phone_number,opening_hours/weekday_text,reviews,website&key=\(api_key)") {
                
                let task = URLSession.shared.dataTask(with: URLRequest(url: url) as URLRequest, completionHandler: { data, response, error in
                    guard error == nil else {
                        detailResponse(nil, error)
                        return
                    }
                    if let data = data, let response = try? JSONDecoder().decode(DetailResponse.self, from: data), let result = response.result {
                        detailResponse(result, nil)
                    }
                })
                task.resume()
            }
        } else {
            if let path = Bundle.main.path(forResource: placeId, ofType: "json", inDirectory: "TestResponses") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    if let response = try? JSONDecoder().decode(DetailResponse.self, from: data), let result = response.result {
                        detailResponse(result, nil)
                    }
                } catch {
                    detailResponse(nil, error)
                }
            }
        }
    }
}

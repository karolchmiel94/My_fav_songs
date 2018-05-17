//
//  WebService.swift
//  My fav songs
//
//  Created by Karol Ch on 16/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import Foundation

protocol APIProtocol {
    func fetchSongs(query: String, onSuccess: @escaping(ResultData) -> Void, onFailure: @escaping(Error) -> Void)
}

class WebService: APIProtocol {
    
    static let HTTP_SCHEME = "https"
    static let HTTP_HOST = "itunes.apple.com"
    static let searchEndPoint = "/search"
    static let RESULT_NUMBER = 25
    
    static let sharedInstance = WebService()
    
    func createUrlComponents() -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = WebService.HTTP_SCHEME
        urlComponents.host = WebService.HTTP_HOST
        urlComponents.path = WebService.searchEndPoint
        return urlComponents
    }
    
    func fetchSongs(query: String, onSuccess: @escaping(ResultData) -> Void, onFailure: @escaping(Error) -> Void){
        var urlComponents = createUrlComponents()
        let songQuery = URLQueryItem(name: "term", value: query)
        let limitQuery = URLQueryItem(name: "limit", value: String(WebService.RESULT_NUMBER))
        let mediumQuery = URLQueryItem(name: "medium", value: "music")
        urlComponents.queryItems = [songQuery, limitQuery, mediumQuery]
        let request = NSMutableURLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else {
                do {
                    let songs = try JSONDecoder().decode(ResultData.self, from: data!)
                    onSuccess(songs)
                } catch let error {
                    onFailure(error)
                }
            }
        })
        task.resume()
    }
}

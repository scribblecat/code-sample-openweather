//
//  DataManager.swift
//  CodeSampleWeather
//
//  Created by sadie on 2/12/18.
//  Copyright © 2018 Sadie Contini. All rights reserved.
//

import Foundation
import Alamofire

typealias JsonObject = Dictionary<String, AnyObject>

enum APIResult<T> {
    case success(T)
    case error(AppError)
}

protocol ApiAdapter {
    static func create(from jsonObj: JsonObject) -> APIResult<Self>
}

class DataManager {
    
    // Singleton
    static let sharedInstance = DataManager()
    private init() {}
    
    var weatherIconDictionary = Dictionary<String, Data>()
    
    // MARK: - Fetch
    
    // TODO: limit to 1 request per city per 10 minutes, as recommended by the API docs
    // TODO: make it so you get multiple responses cities with same name
    // associate fetch time with weather
    func fetchWeather(for cityName: String,
                      closure: @escaping (APIResult<Weather>) -> Void) {
        
        // endpoint example
        // /data/2.5/weather?q=London&APPID=4a96f2eae43e2cc53e4cf97b95e7a543
        // http://api.openweathermap.org/data/2.5/weather?q=Binghamton&APPID=4a96f2eae43e2cc53e4cf97b95e7a543
        let urlString = Constant.API.baseUrl + "/data/2.5/weather"
        let parameters = [
            "q": cityName, // TODO: handle spaces?
            "appid": Constant.API.key
        ]
        
        fetch(dataType: Weather.self,
              requestUrlString: urlString,
              parameters: parameters,
              closure: closure)
    }
    
    private func fetch<T: ApiAdapter>(dataType: T.Type,
                                      requestUrlString: String,
                                      parameters: Dictionary<String, Any>,
                                      closure: @escaping (APIResult<T>) -> Void) {
        
        guard let requestUrl = URL(string: requestUrlString) else {
            // TODO: use localized string for userMessage
            let userMessage = "Server error. Try again."
            let debug = "Request URL invalid: " + requestUrlString
            let error = AppError.ApiError(message: userMessage,
                                          debug: debug)
            closure(APIResult.error(error))
            return
        }
        
        Alamofire.request(
            requestUrl,
            parameters: parameters,
            // JSONEncoding.default causes Timeout for openweather API response
            encoding: URLEncoding.default,
            headers: nil) // is optional : HTTPHeaders?
            .validate()
            .responseJSON {
                [weak self] (response) -> Void in
                guard response.result.isSuccess else {
                    // TODO: use localized string for userMessage
                    // TODO: pass server error as server error into debug?
                    // TODO: parse error for 404
                    /*
                     Optional(<NSHTTPURLResponse: 0x60000022a540> {
                        URL: http://api.openweathermap.org/data/2.5/weather?appid=4a96f2eae43e2cc53e4cf97b95e7a543&q=Ro
                     }
                     {
                     Status Code: 404,
                     Headers {
                     "Access-Control-Allow-Credentials" =     (true);
                     "Access-Control-Allow-Methods" =     ("GET, POST");
                     "Access-Control-Allow-Origin" =     ("*");
                     Connection =     ("keep-alive");
                     "Content-Length" =     (40);
                     "Content-Type" =     ("application/json; charset=utf-8");
                     Date =     ("Wed, 14 Feb 2018 00:29:47 GMT");
                     Server =     (openresty);
                     "X-Cache-Key" =     ("/data/2.5/weather?q=ro");
                     }}
                     */
                    
                    // TODO: redo errors so that front end checks for type of issue and then gives user message
                    // only front end would know if user searched for a city or something else.
                    let userMessage = "Unable to find that city. Try again."
                    let responseDebug = self?.debugString(for: response) ?? ""
                    let debug = "Error while fetching remote items: " + responseDebug
                    let error = AppError.ApiError(message: userMessage,
                                                  debug: debug)
                    closure(APIResult.error(error))
                    return
                }
                
                guard let data = response.result.value as? JsonObject else {
                    // TODO: use localized string for userMessage
                    let userMessage = "Server error. Try again."
                    let responseDebug = self?.debugString(for: response) ?? ""
                    let debug = "Malformed data received from api: " + responseDebug
                    let error = AppError.JsonParsingError(message: userMessage,
                                                          debug: debug)
                    closure(APIResult.error(error))
                    return
                }
                closure(dataType.create(from: data))
        }
    }
    
    func fetchWeatherIcon(for imageName: String,
                          closure: @escaping (APIResult<Data>) -> Void) {
        
        if let imgData = weatherIconDictionary[imageName] {
            closure(APIResult.success(imgData))
            return
        }
        
        let urlString = Constant.API.baseUrl + "/img/w/\(imageName).png"
        
        guard let remoteImageURL = URL(string: urlString) else {
            return
        }
        
        Alamofire.request(remoteImageURL).responseData {
            [weak self] (response) in
            if response.error == nil {
                if let data = response.data {
                    // cache-ing image
                    // TODO: manage cache size
                    self?.weatherIconDictionary[imageName] = data
                    closure(APIResult.success(data))
                }
            } else {
                // TODO: use localized string for userMessage
                let userMessage = "Error while fetching image"
                let responseDebug = self?.debugString(for: response) ?? ""
                let debug = "Error while fetching image: " + responseDebug
                let error = AppError.ApiError(message: userMessage,
                                              debug: debug)
                closure(APIResult.error(error))
            }
        }
    }
    
    func debugString(for response: DataResponse<Any>) -> String {
        // TODO: verify if this is the data we want to see
        var debugString = "request: \(String(describing: response.request))"
        debugString += "\nresponse: \(String(describing: response.response))"
        debugString += "\ndata: \(String(describing: response.data))"
        debugString += "\nresult: \(response.result)" // serialized response
        return debugString
    }
    
    // TODO: consolidate this method for different DataResponse types if possible
    // TODO: does this work? do these fields exist?
    func debugString(for response: DataResponse<Data>) -> String {
        // TODO: verify if this is the data we want to see
        var debugString = "request: \(String(describing: response.request))"
        debugString += "\nresponse: \(String(describing: response.response))"
        debugString += "\ndata: \(String(describing: response.data))"
        debugString += "\nresult: \(response.result)" // serialized response
        return debugString
    }
}

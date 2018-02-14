//
//  Weather.swift
//  CodeSampleWeather
//
//  Created by sadie on 2/12/18.
//  Copyright © 2018 Sadie Contini. All rights reserved.
//

import Foundation

struct Weather {
    // TODO: city would be a nice thing to have
    // TODO: give user option to choose between cities with common names --
    // i.e. Portland could be Oregon or Maine. Have to figure that out
    // with API.
    let cityName: String
    let country: String
    let title: String
    let titleIconName: String
    let temp: Double // celsius
    let tempMax: Double
    let tempMin: Double
}

extension Weather: ApiAdapter {
    
    /* sample api response for weather
     {
         "coord": {
             "lon": -75.91,
             "lat": 42.1
         },
         "weather": [
         {
             "id": 800,
             "main": "Clear",
             "description": "clear sky",
             "icon": "01d"
         }
         ],
         "base": "stations",
         "main": {
             "temp": 270.7,
             "pressure": 1031,
             "humidity": 53,
             "temp_min": 270.15,
             "temp_max": 271.15
         },
         "visibility": 16093,
         "wind": {
             "speed": 6.2,
             "deg": 320,
             "gust": 10.8
         },
         "clouds": {
             "all": 1
         },
         "dt": 1518468960,
         "sys": {
             "type": 1,
             "id": 2091,
             "message": 0.005,
             "country": "US",
             "sunrise": 1518436951,
             "sunset": 1518474824
         },
         "id": 5109177,
         "name": "Binghamton",
         "cod": 200
     }
    */
    static func create(from jsonObj: JsonObject) -> APIResult<Weather> {
        // TODO: consider de-stringifying json keys
        guard let cityName = jsonObj["name"] as? String,
            
            let weatherJson = jsonObj["weather"] as? [JsonObject],
            let weatherData = weatherJson.first,
            let title = weatherData["main"] as? String,
            let titleIconName = weatherData["icon"] as? String,
            
            let mainJson = jsonObj["main"] as? JsonObject,
            let temp = mainJson["temp"] as? Double,
            let tempMax = mainJson["temp_max"] as? Double,
            let tempMin = mainJson["temp_min"] as? Double,
        
            let sysJson = jsonObj["sys"] as? JsonObject,
            let country = sysJson["country"] as? String else {
                // TODO: check api guidelines -- maybe not all fields must be filled
                // and this should fill out as much of weather as it can without assuming
                // complete data will exist.
                return APIResult.error(AppError.JsonParsingError(message: "Unable to parse all fields.", debug: "Unable to parse all fields: \(jsonObj)"))
        }
        let weather = Weather.init(cityName: cityName,
                                   country: country,
                                   title: title,
                                   titleIconName: titleIconName,
                                   temp: temp,
                                   tempMax: tempMax,
                                   tempMin: tempMin)
        return APIResult.success(weather)
    }
}

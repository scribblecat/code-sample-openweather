//
//  WeatherApiAdapterTests.swift
//  CodeSampleWeatherTests
//
//  Created by sadie on 2/13/18.
//  Copyright © 2018 Sadie Contini. All rights reserved.
//

import XCTest

@testable import CodeSampleWeather

// TODO: Leave near Weather.swift so it's easy to see which classes have tests
class WeatherTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreateWithJsonObject() {
        guard let json = weatherJson() else {
            XCTFail("unable to convert text to json")
            return
        }
        
        let weatherResult = Weather.create(from: json)
        
        switch weatherResult {
            
        case .success(let weather):
            XCTAssert(weather.cityName == "Binghamton", "city should be Binghamton, was: \(weather.cityName)")
            XCTAssert(weather.title == "Clear",
                      "title should be Clear, was: \(weather.title)")
            XCTAssert(weather.temp.isEqual(to: 270.7),
                      "temp should be 270.7, was: \(weather.temp)")
            XCTAssert(weather.tempMin.isEqual(to: 270.15),
                      "min temp should be 270.15, was: \(weather.tempMin)")
            XCTAssert(weather.tempMax.isEqual(to: 271.15),
                      "max temp should be 271.15, was: \(weather.tempMax)")
            XCTAssert(weather.titleIconName == "01d",
                      "icon should be 01d, was: \(weather.titleIconName)")
            XCTAssert(weather.country == "US",
                      "country should be US, was: \(weather.country)") 
        case .error:
            XCTFail("Weather.create(from: json) returned error")
        }
    }
    
    // TODO: make method less demanding? :) 
    // Make sure we don't get weather struct unless we have all expected data.
    func testCreateWithJsonObjectFail() {
        guard let incompleteJson = weatherBadJson() else {
            XCTFail("unable to convert text to json")
            return
        }
        
        let weatherResult = Weather.create(from: incompleteJson)
        
        switch weatherResult {
            
        case .success(_):
            // As written now, code should fail because icon mission
            XCTFail("Weather.create(from: json) returned weather without icon, but should require icon in json...")
        case .error:
            XCTAssertTrue(true, "Well done. This should be an error result.")
        }
    }
    
    // MARK: - Helper Methods
    
    func weatherJson() -> JsonObject? {
        
        let jsonString = """
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
"""
        return convertToJson(text: jsonString)
    }
    
    func weatherBadJson() -> JsonObject? {
        // removed main.icon field
        let jsonString = """
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
"""
        return convertToJson(text: jsonString)
    }
    
    func convertToJson(text: String) -> JsonObject? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? JsonObject
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}


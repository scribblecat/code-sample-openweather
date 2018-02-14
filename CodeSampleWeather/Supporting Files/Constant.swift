//
//  Constant.swift
//  CodeSampleWeather
//
//  Created by sadie on 2/12/18.
//  Copyright © 2018 Sadie Contini. All rights reserved.
//

import Foundation

struct Constant {
    struct API {
        // i.e. http://api.openweathermap.org/data/2.5/weather?q=London&APPID=4a96f2eae43e2cc53e4cf97b95e7a543
        
        // TODO: move to user defined build variable so we can use in plist for transport security exception
        static let baseUrl = "http://api.openweathermap.org"
        static let key = "4a96f2eae43e2cc53e4cf97b95e7a543"
    }
    
    struct UserDefaultsKey {
        static let lastSearchCity = "lastSearchCity"
    }
    
    struct ErrorCode {
        static let api = 1
        static let jsonParse = 2
    }
}

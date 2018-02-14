//
//  UserDefaultsService.swift
//  CodeSampleWeather
//
//  Created by sadie on 2/13/18.
//  Copyright © 2018 Sadie Contini. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    class func lastSearchCity() -> String? {
        return (UserDefaults().value(forKey: Constant.UserDefaultsKey.lastSearchCity) as? String) ?? nil
    }
    
    class func setLastSearchCity(name: String){
        UserDefaults().setValue(name,
                                forKey: Constant.UserDefaultsKey.lastSearchCity)
        UserDefaults().synchronize()
    }
}

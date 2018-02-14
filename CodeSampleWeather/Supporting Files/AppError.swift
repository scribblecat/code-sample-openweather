//
//  AppError.swift
//  CodeSampleWeather
//
//  Created by sadie on 2/12/18.
//  Copyright © 2018 Sadie Contini. All rights reserved.
//

import Foundation
import UIKit

// TODO: redesign app error. have error type and let vc
// decide what to show user.
// TODO: deal with device not online
enum AppError: Error, CustomStringConvertible {
    
    //    case NetworkError(code: Int)
    case ApiError(message: String, debug: String)
    case JsonParsingError(message: String, debug: String)

    var userMessage: String {
        switch self {
        case .ApiError(let message, _):
            return message
            // TODO: deal with device not online
            //        case .NetworkError(let code):
        //            return "NetworkError: \(code)"
        case .JsonParsingError(let message, _):
            return message
        }
    }
    
    var debugMessage: String {
        switch self {
        case .ApiError(_, let debug):
            return debug
            //        case .NetworkError(let code):
        //            return "NetworkError: \(code)"
        case .JsonParsingError(_, let debug):
            return debug
        }
    }
    
    var description: String {
        switch self {
        case .ApiError(let message, let debug):
            return "ApiError: " + message + debug
            //        case .NetworkError(let code):
            //            return "NetworkError: \(code)"
        case .JsonParsingError(let message, let debug):
            return "JsonParsingError: " + message + debug
        }
    }
    
    func handle() {
        // TODO: error.localizedDescription or error.description as defined above?
        let message = description + " -- " + localizedDescription
        print(message)
        AlertController.presentOkAlert(title: "Error",
                                       message: message)
     }
}



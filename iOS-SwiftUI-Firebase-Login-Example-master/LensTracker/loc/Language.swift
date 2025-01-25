//
//  Language.swift
//  LocalizationOnTheFly
//
//  Created by Антон Савинов on 30.01.2021.
//

import Foundation

enum Language: String {

    case hungarian = "hu"
    case english_us = "en"

    
    var userSymbol: String {
        switch self {
        case .english_us:
            return "us"
        default:
            return rawValue
        }
    }
}

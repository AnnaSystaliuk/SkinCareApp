//
//  Enums.swift
//  SkincareApp
//
//  Created by Anna on 10/21/21.
//

import Foundation


enum Weekday: Int16 {
    case Monday = 0
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
}

enum ProductType: Int16 {
    case Cleanser = 0
    case Toner
    case Treatment
    case Moisturizer
    case Sunscreen
    case Exfoliator
}

enum ProductTime: Int16 {
    case Day = 0
    case Night
}

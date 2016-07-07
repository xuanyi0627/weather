//  
//  Temperature.swift
//  Weather
//
//  Created by Echo on 16/3/31.
//  Copyright © 2016年 iDareX. All rights reserved.
//

import Foundation

struct Temperature {
  let degrees: String
  
  init(country: String, openWeatherMapDegrees: Double) {
    if country == "US" {
      // Convert temperature to Fahrenheit if user is within the US
      degrees = String(round(((openWeatherMapDegrees - 273.15) * 1.8) + 32)) + "\u{f045}"
    } else {
      // Otherwise, convert temperature to Celsius
      degrees = String(round(openWeatherMapDegrees - 273.15)) + "\u{f03c}"
    }
  }
}

//
//  NextTwoVariableAutoTemperatureModel.swift
//  WeatherApp
//
//  Created by Hung Doan on 7/9/20.
//  Copyright © 2020 Hung Doan. All rights reserved.
//

import Foundation

struct NextTwoVariableAutoTemperatureModel: Codable
{
   let Current_Temperature : Float
   let Current_Humidity : Float
   let Next_Temperature: Float
}

//
//  ChartModel.swift
//  neoNetwork
//
//  Created by Alexander Sung on 1/30/18.
//  Copyright © 2018 Alexander Sung. All rights reserved.
//

import Foundation

struct ChartData: Codable {
    let Response: String
    let TimeTo: Int
    let TimeFrom: Int
    let Data: [PointData]
}

struct PointData: Codable {
    let time: Int
    let open: Double
}

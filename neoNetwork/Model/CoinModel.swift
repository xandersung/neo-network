//
//  CoinModel.swift
//  neoNetwork
//
//  Created by Alexander Sung on 1/20/18.
//  Copyright © 2018 Alexander Sung. All rights reserved.
//

import Foundation

struct Coin: Codable {
    let name: String
    let symbol: String
    let price_usd: String
    let price_btc: String
    let percent_change_24h: String
}

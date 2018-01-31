//
//  QueryService.swift
//  neoNetwork
//
//  Created by Alexander Sung on 1/20/18.
//  Copyright © 2018 Alexander Sung. All rights reserved.
//

import Foundation
import Charts

// Runs query data task
class QueryService {
    
    private weak var currentVC: ViewController!
    
    func retrieveNEOPrices(currentVC:ViewController) {
        
        let urlString = "https://api.coinmarketcap.com/v1/ticker/neo/"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let coinData = try JSONDecoder().decode([Coin].self, from: data)
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    print(coinData)
                    currentVC.neoData = coinData[0]
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    
    func retrieveNEP5Prices(currentVC:ViewController) {
        
        self.currentVC = currentVC

        let urlStringGAS = "https://api.coinmarketcap.com/v1/ticker/gas/"
        let urlStringRPX = "https://api.coinmarketcap.com/v1/ticker/red-pulse/"
        let urlStringDBC = "https://api.coinmarketcap.com/v1/ticker/deepbrain-chain/"
        let urlStringQLINK = "https://api.coinmarketcap.com/v1/ticker/qlink/"
        let tokenURLArray = [urlStringGAS, urlStringRPX, urlStringDBC, urlStringQLINK]
        
        for url in tokenURLArray {
            getTokenData(urlString: url)
        }

    }
    
    func getTokenData(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let coinData = try JSONDecoder().decode([Coin].self, from: data)
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    print(coinData)
//                    if self.currentVC.nep5Data?.append(coinData[0]) == nil {
//                        self.currentVC.nep5Data = coinData
//                    }
                    self.currentVC.nep5Data[coinData[0].symbol] = coinData[0]
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
        
    }
    
    func retrieveNEOChartData(currentVC:ViewController) {
        
        let urlString = "https://min-api.cryptocompare.com/data/histominute?fsym=NEO&tsym=USD&limit=480&aggregate=3&e=CCCAGG"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let chartData = try JSONDecoder().decode(ChartData.self, from: data)
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    print(chartData.Data)
                    var dataValueArray: [ChartDataEntry] = []
                    var counter = 0
                    for point in chartData.Data {
                        dataValueArray.append(ChartDataEntry(x: Double(point.time), y: point.open))
                        //y: Double(point.time)
                        counter = counter + 1
                    }
//                    while counter < 25 {
//                        dataValueArray.append(ChartDataEntry(x:Double(counter) ,y:chartData.Data[counter].open / 100))
//                        //y: Double(point.time)
//                        counter = counter + 1
//                    }
                    let dataSet = LineChartDataSet(values: dataValueArray, label: "Neo")
                    currentVC.neoChartSet = dataSet
//                    currentVC.neoData = coinData[0]
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }

}


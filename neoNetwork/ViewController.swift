//
//  ViewController.swift
//  neoNetwork
//
//  Created by Alexander Sung on 1/19/18.
//  Copyright © 2018 Alexander Sung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var neoPriceLabel: UILabel!
    private var usdPrice: String!
    private var displayUSD = true
    var coins: [Coin]? {
        didSet {
            neoPriceLabel.text = "$" + coins![0].price_usd
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UIApplication.shared.statusBarStyle = .lightContent
        
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
                    self.coins = coinData
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            
            }.resume()
        updatePrice()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func updatePrice() {
    }
    
    @IBAction func currencyButton(_ sender: UIButton) {
        if displayUSD {
            sender.setImage(#imageLiteral(resourceName: "BTC-highlight"), for: .normal)
            displayUSD = false
            neoPriceLabel.text = "฿ " + coins![0].price_btc
        } else {
            sender.setImage(#imageLiteral(resourceName: "USD-highlight"), for: .normal)
            displayUSD = true
            neoPriceLabel.text = "$ " + coins![0].price_usd
        }
    }
    
}

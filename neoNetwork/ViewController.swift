//
//  ViewController.swift
//  neoNetwork
//
//  Created by Alexander Sung on 1/19/18.
//  Copyright © 2018 Alexander Sung. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ChartViewDelegate {

    @IBOutlet weak var neoPriceLineChartView: LineChartView!
    @IBOutlet weak var icoCollectionView: UICollectionView!
    @IBOutlet weak var nep5CollectionView: UICollectionView!
    @IBOutlet weak var neoPriceLabel: UILabel!
    @IBOutlet weak var neoDeltaLabel: UILabel!
    private var usdPrice: String!
    private var displayUSD = true
    @IBOutlet weak var selectedTimeLabel: UILabel!
    var neoData: Coin! {
        didSet {
            updateNeoPrice()
        }
    }
    var nep5Data: [String:Coin] = [:] {
        didSet {
            if nep5Data.count == 4 {
                updateNEP5Prices()
            }
        }
    }
    var neoChartSet: LineChartDataSet? {
        didSet {
            lineChartUpdate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UIApplication.shared.statusBarStyle = .lightContent
        QueryService().retrieveNEOPrices(currentVC: self)
        QueryService().retrieveNEP5Prices(currentVC: self)
        QueryService().retrieveNEOChartData(currentVC: self)
        
        // set up chart
        lineChartUpdate()
        setLineChartUI()
        neoPriceLineChartView.delegate = self
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenWidth, height: 70)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        nep5CollectionView.collectionViewLayout = layout
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nep5CollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateNeoPrice() {
        let neoPrice = Double(neoData.price_usd)
        let neoDelta = neoData.percent_change_24h
        neoPriceLabel.text = "$" + String(format:"%.2f", neoPrice!)
        neoDeltaLabel.text = neoDelta + "%"
        if neoDelta[neoDelta.startIndex] == "-" {
            neoDeltaLabel.textColor = UIColor.red
        } else {
            neoDeltaLabel.textColor = UIColor.green
        }
    }
    
    func setLineChartUI() {
        neoPriceLineChartView.legend.textColor = UIColor.white
        neoPriceLineChartView.chartDescription?.textColor = UIColor.white
        neoPriceLineChartView.legend.enabled = false
        neoPriceLineChartView.leftAxis.enabled = false
        neoPriceLineChartView.leftAxis.spaceTop = 0.4
        neoPriceLineChartView.leftAxis.spaceBottom = 0.4
        neoPriceLineChartView.rightAxis.enabled = false
        neoPriceLineChartView.xAxis.enabled = false
        neoPriceLineChartView.highlightPerTapEnabled = true
        neoPriceLineChartView.doubleTapToZoomEnabled = false
        neoPriceLineChartView.setNeedsLayout()
        
    }
    
    // chart view delegate functions
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
        print(highlight)
        neoPriceLabel.text = "$" + String(highlight.y)
        let date = Date(timeIntervalSince1970: highlight.x)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "h:mm a" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        selectedTimeLabel.text = strDate
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        updateNeoPrice()
        selectedTimeLabel.text = ""
    }
    
    
    func lineChartUpdate() {
        if let dataSet = neoChartSet {
            // update set UI
            dataSet.drawValuesEnabled = false
            dataSet.valueTextColor = .white
            dataSet.setColor(.green)
            dataSet.circleRadius = 0
            dataSet.circleHoleRadius = 0
            dataSet.setCircleColor(.white)
            dataSet.highlightColor = .white
            dataSet.drawHorizontalHighlightIndicatorEnabled = false
            
            let data = LineChartData(dataSets: [dataSet])
            neoPriceLineChartView.data = data
            neoPriceLineChartView.chartDescription?.text = ""
            
            //All other additions to this function will go here
            
            //This must stay at end of function
            neoPriceLineChartView.notifyDataSetChanged()
        }
    }
    
    func updateNEP5Prices() {
        print(nep5Data)
        self.nep5CollectionView.reloadData()
    }

    @IBAction func chartViewTapped(_ sender: Any) {
        neoPriceLineChartView.highlightValues(nil)
        updateNeoPrice()
        selectedTimeLabel.text = ""
    }
    
    @IBAction func currencyButton(_ sender: UIButton) {
        if displayUSD {
            sender.setImage(#imageLiteral(resourceName: "BTC-highlight"), for: .normal)
            displayUSD = false
            neoPriceLabel.text = "฿" + neoData.price_btc
        } else {
            sender.setImage(#imageLiteral(resourceName: "USD-highlight"), for: .normal)
            displayUSD = true
            
            //todo refactor
            let neoPrice = Double(neoData.price_usd)
            neoPriceLabel.text = "$" + String(format:"%.2f", neoPrice!)
        }
        self.nep5CollectionView.reloadData()
    }
    
    //collection view conform
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == icoCollectionView {
            return 9
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == icoCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "icoCell", for: indexPath) as! ICOCell
            let icoLabels = ["APEX", "Orbis", "THOR", "Alphacat", "Ontology", "Narrative", "Veris", "Moonlight", "ATLAS"]
            cell.displayICOLabel(title: icoLabels[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nep5Cell", for: indexPath) as! NEP5Cell
            let nep5Labels = ["Gas", "Red Pulse (RPX)", "DeepBrain Chain (DBC)", "QLINK"]
            let nep5Symbols = ["GAS", "RPX", "DBC", "QLC"]
            let nep5Images = [#imageLiteral(resourceName: "NEOLogo"), #imageLiteral(resourceName: "RPXLogo"), #imageLiteral(resourceName: "DBCLogo"), #imageLiteral(resourceName: "QLINKLogo")]
            
            cell.displayNEP5Label(title: nep5Labels[indexPath.row])
            cell.displayNEP5Image(image: nep5Images[indexPath.row])
            
            if let coinData = nep5Data[nep5Symbols[indexPath.row]] {
                if displayUSD {
                    cell.updateNEP5Price(currency: "$" + coinData.price_usd, delta: coinData.percent_change_24h + "%")
                } else {
                    cell.updateNEP5Price(currency: "฿" + coinData.price_btc, delta: coinData.percent_change_24h + "%")
                }
            }
            
            //todo fix hiding cell divider
            if indexPath.row == nep5Labels.count - 1 {
                cell.cellDividerView.isHidden = true
            } else {
                cell.cellDividerView.isHidden = false
            }
            return cell
        }
    }
    
}



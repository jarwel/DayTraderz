//
//  SecurityViewController.swift
//  DayTrades
//
//  Created by Jason Wells on 7/16/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class SecurityViewController: UIViewController {
    
    @IBOutlet weak var priceChart: PriceChart!

    var symbol: String = "YHOO"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceChart.reloadDataForSymbol(symbol, start: "2015-01-01", end: "2015-06-30");
    }
    
}
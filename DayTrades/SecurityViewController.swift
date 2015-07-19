//
//  SecurityViewController.swift
//  DayTrades
//
//  Created by Jason Wells on 7/16/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class SecurityViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var picksLabel: UILabel!
    @IBOutlet weak var priceChart: PriceChart!

    let calendar: NSCalendar = NSCalendar.gregorianCalendarInEasternTime()
    
    var symbol: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = nil
        picksLabel.text = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let start: String = startDayOfTrade()
        let end: String = endDateOfTrade()
        if symbol != nil {
            ParseClient.fetchSecurityForSymbol(symbol!, block: { (object: PFObject?, error: NSError?) -> Void in
                if let security: Security = object as? Security {
                    if security.name != nil {
                        self.nameLabel.text = "\(security.name!) (\(security.symbol))"
                    }
                    else {
                        self.nameLabel.text = security.symbol
                    }
                    self.picksLabel.text = "Picked \(security.picks) times"
                    self.priceChart.reloadDataForSymbol(security.symbol, start: start, end: end);
                }
                else {
                    self.nameLabel.text = self.symbol
                }
            });
        }
    }
    
    func startDayOfTrade() -> String {
        let date = calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: -60, toDate: NSDate(), options: nil)!
        return MarketHelper.previousDayOfTradeFromDate(date)
    }
    
    func endDateOfTrade() -> String {
        return MarketHelper.previousDayOfTradeFromDate(NSDate())
    }
    
}
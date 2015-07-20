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
    var security: Security?
    var dayOfTrades: Array<String> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = nil
        picksLabel.text = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let symbol: String = self.symbol {
            ParseClient.fetchSecurityForSymbol(symbol, block: { (object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    self.security = object as? Security
                    self.refreshView()
                }
                else {
                    println("Error \(error) \(error!.userInfo)")
                }
            });
            let start: String = startDayOfTrade()
            let end: String = endDateOfTrade()
            FinanceClient.fetchDayQuotesForSymbol(symbol, start: start, end: end) { (response: NSURLResponse!, data: NSData!, error: NSError?) -> Void in
                if error == nil {
                    let quotes: Array<DayQuote> = DayQuote.fromData(data).reverse()
                    self.priceChart.reloadDataForQuotes(quotes)
                }
                else {
                    println("Error \(error) \(error!.userInfo)")
                }
            }
        }
    }
    
    func refreshView() {
        if let security:Security = self.security{
            if let name: String = security.name {
                self.nameLabel.text = "\(security.name!) (\(security.symbol))"
            }
            else {
                self.nameLabel.text = security.symbol
            }
            if (security.picks == 1) {
                self.picksLabel.text = "Picked 1 time"
            }
            else {
                 self.picksLabel.text = "Picked \(security.picks) times"
            }
        }
        else {
            self.nameLabel.text = self.symbol
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
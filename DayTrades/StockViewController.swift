//
//  StockViewController.swift
//  DayTrades
//
//  Created by Jason Wells on 7/16/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class StockViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var picksLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var stockChart: StockChart!

    let disabledSymbols: NSArray = NSBundle.mainBundle().objectForInfoDictionaryKey("Disabled symbols") as! NSArray
    let calendar: NSCalendar = NSCalendar.gregorianCalendarInEasternTime()
    
    var dayOfTrades: Array<String> = Array()
    var symbol: String?
    var stock: Stock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let backgroundImage: UIImage = UIImage(named: "background-4.jpg") {
            view.backgroundColor = UIColor(patternImage: backgroundImage)
        }
        topView.backgroundColor = UIColor.translucentColor()
        nameLabel.text = nil
        picksLabel.text = nil
        submitButton.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let symbol: String = self.symbol {
            if !disabledSymbols.containsObject(symbol.uppercaseString) {
                ParseClient.fetchNextPick { (object: PFObject?, error: NSError?) -> Void in
                    if let pick: Pick = object as? Pick {
                        if pick.symbol != symbol {
                            self.submitButton?.hidden = false
                        }
                    }
                    if let error: NSError = error {
                        if error.code == 101 {
                            self.submitButton?.hidden = false
                        }
                    }
                }
            }
        
            ParseClient.fetchStockForSymbol(symbol, block: { (object: PFObject?, error: NSError?) -> Void in
                if let stock: Stock = object as? Stock {
                    self.stock = stock
                }
                self.refreshView()
            });
            let start: String = startDayOfTrade()
            let end: String = endDateOfTrade()
            FinanceClient.fetchDayQuotesForSymbol(symbol, start: start, end: end) { (response: NSURLResponse!, data: NSData!, error: NSError?) -> Void in
                if let data: NSData = data {
                    let quotes: Array<DayQuote> = DayQuote.fromData(data)
                    self.stockChart.reloadDataForQuotes(quotes)
                }
            }
        }
        else {
            refreshView()
        }
    }
    
    func refreshView() {
        nameLabel.text = symbol
        if let stock: Stock = self.stock {
            if let name: String = stock.name {
                if count(name) > 0 {
                    nameLabel.text = "\(stock.name!) (\(stock.symbol))"
                }
            }
            if (stock.picks == 1) {
                self.picksLabel.text = "1 pick"
            }
            else {
                 self.picksLabel.text = "\(stock.picks) picks"
            }
        }
    }
    
    func startDayOfTrade() -> String {
        let date = calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: -45, toDate: NSDate(), options: nil)!
        return MarketHelper.previousDayOfTradeFromDate(date)
    }
    
    func endDateOfTrade() -> String {
        return MarketHelper.previousDayOfTradeFromDate(NSDate())
    }
    
    @IBAction func onSubmitButtonTouched(sender: AnyObject) {
        if let symbol: String = self.symbol {
            ParseClient.setNextPick(symbol, block: { (succeeded: Bool, error: NSError?) -> Void in
                if succeeded {
                    NSNotificationCenter.defaultCenter().postNotificationName(Notification.NextPickUpdated.description, object: nil)
                    self.submitButton.hidden = true
                }
            })
        }
    }
    
}
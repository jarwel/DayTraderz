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
    
    var symbol: String?
    var stock: Stock?
    var nextPick: Pick?
    
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
                    if let nextPick: Pick = object as? Pick {
                        if nextPick.symbol == symbol {
                            self.nextPick = nextPick
                        }
                    }
                    self.refreshNextPickView()
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
            if stock.picks == 1 {
                self.picksLabel.text = "Picked 1 time"
            }
            else if stock.picks > 1 {
                 self.picksLabel.text = "Picked \(stock.picks) times"
            }
        }
    }
    
    func refreshNextPickView() {
        submitButton.setTitle("Place Trade", forState: UIControlState.Normal)
        submitButton.hidden = false
        if let nextPick: Pick = self.nextPick {
            if nextPick.symbol == symbol {
                submitButton.setTitle("Remove Pick", forState: UIControlState.Normal)
                submitButton.hidden = false
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
        if let nextPick: Pick = self.nextPick {
            if let nextPick: Pick = self.nextPick {
                submitButton.enabled = false
                ParseClient.deletePick(nextPick, block: { (succeeded: Bool, error: NSError?) -> Void in
                    if succeeded {
                        self.nextPick = nil
                        self.refreshNextPickView()
                    }
                    self.submitButton.enabled = true
                })
            }
        }
        else {
            if let symbol: String = self.symbol {
                submitButton.enabled = false
                ParseClient.setNextPick(symbol, block: { (object: PFObject?, error: NSError?) -> Void in
                    if let nextPick: Pick = object as? Pick {
                        NSNotificationCenter.defaultCenter().postNotificationName(Notification.NextPickUpdated.description, object: nil)
                        self.nextPick = nextPick
                        self.refreshNextPickView()
                    }
                    self.submitButton.enabled = true
                })
            }
        }
    }
    
}
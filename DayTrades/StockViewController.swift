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
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    
    var symbol: String?
    var stock: Stock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let backgroundImage: UIImage = UIImage(named: "background-4.jpg") {
            view.backgroundColor = UIColor(patternImage: backgroundImage)
        }
        topView.backgroundColor = UIColor.translucentColor()
        submitButton.layer.cornerRadius = 4
        submitButton.hidden = true
        nameLabel.text = nil
        picksLabel.text = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let symbol: String = self.symbol {
            if !disabledSymbols.containsObject(symbol.uppercaseString) {
                submitButton.hidden = false
            }
            ParseClient.fetchStockForSymbol(symbol, block: { (object: PFObject?, error: NSError?) -> Void in
                if let stock: Stock = object as? Stock {
                    self.stock = stock
                }
                self.refreshView()
            });
            let start: String = startDayOfTrade()
            let end: String = endDateOfTrade()
            FinanceClient.fetchDayQuotesForSymbol(symbol, start: start, end: end) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if let data: NSData = data {
                    let quotes: [DayQuote] = DayQuote.fromData(data)
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
                if name.characters.count > 0 {
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
    
    func startDayOfTrade() -> String {
        let date = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -45, toDate: NSDate(), options: [])!
        return MarketHelper.previousDayOfTradeFromDate(date)
    }
    
    func endDateOfTrade() -> String {
        return MarketHelper.previousDayOfTradeFromDate(NSDate())
    }
    
    @IBAction func onSubmitButtonTouched(sender: AnyObject) {
        let dateText: String? = dateFormatter.fullTextFromDayOfTrade(MarketHelper.nextDayOfTrade())
        let message: String = "Shares will be purchased for the opening price and sold at market close. Trades are final at 6:00 a.m. eastern time on \(dateText!)."
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Destructive, handler: onConfirmButtonTouched))
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    private func onConfirmButtonTouched(alertAction: UIAlertAction) -> Void {
        if let symbol: String = self.symbol {
            ParseClient.setNextPick(symbol, block: { (succeeded: Bool, error: NSError?) -> Void in
                if succeeded {
                    self.submitButton.hidden = true
                    NSNotificationCenter.defaultCenter().postNotificationName(Notification.NextPickUpdated.rawValue, object: nil)
                }
            })
        }
    }
    
}
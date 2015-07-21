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
    @IBOutlet weak var stockChart: StockChart!

    let calendar: NSCalendar = NSCalendar.gregorianCalendarInEasternTime()
    
    var symbol: String?
    var stock: Stock?
    var dayOfTrades: Array<String> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let backgroundImage: UIImage = UIImage(named: "background-2.jpg") {
            view.backgroundColor = UIColor(patternImage: backgroundImage)
        }
        topView.backgroundColor = UIColor.translucentColor()
        nameLabel.text = nil
        picksLabel.text = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let symbol: String = self.symbol {
            ParseClient.fetchSecurityForSymbol(symbol, block: { (object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    self.stock = object as? Stock
                    self.refreshView()
                }
                else {
                    println("Error \(error) \(error!.userInfo)")
                }
            });
            let start: String = startDayOfTrade()
            let end: String = endDateOfTrade()
            FinanceClient.fetchDayQuotesForSymbol(symbol, start: start, end: end) { (response: NSURLResponse!, data: NSData!, error: NSError?) -> Void in
                if let data: NSData = data {
                    let quotes: Array<DayQuote> = DayQuote.fromData(data)
                    self.stockChart.reloadDataForQuotes(quotes)
                }
                if let error: NSError = error {
                    println("Error \(error) \(error.userInfo)")
                }
            }
        }
    }
    
    func refreshView() {
        if let stock: Stock = self.stock {
            if let name: String = stock.name {
                self.nameLabel.text = "\(stock.name!) (\(stock.symbol))"
            }
            else {
                self.nameLabel.text = stock.symbol
            }
            if (stock.picks == 1) {
                self.picksLabel.text = "Picked 1 time"
            }
            else {
                 self.picksLabel.text = "Picked \(stock.picks) times"
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
    
    @IBAction func onSubmitButtonTouched(sender: AnyObject) {
        
    }
    
}
//
//  SearchViewController.swift
//  DayTrades
//
//  Created by Jason Wells on 7/12/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class SearchViewController: UIViewController, UISearchBarDelegate, UIActionSheetDelegate {
    
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var stockView: UIView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var dayOfTradeLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    let disabledSymbols: NSArray = NSBundle.mainBundle().objectForInfoDictionaryKey("Disabled symbols") as! NSArray
    let changeFormatter: ChangeFormatter = ChangeFormatter()
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    let numberFormatter: NSNumberFormatter = NSNumberFormatter()
    
    var quote: Quote?
    var requestNumber: UInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let backgroundImage: UIImage = UIImage(named: "background-2.jpg") {
            view.backgroundColor = UIColor(patternImage: backgroundImage)
        }
        detailsView.backgroundColor = UIColor.translucentColor()
        stockView.backgroundColor = UIColor.translucentColor()
        submitButton.layer.cornerRadius = 4
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshView()
    }
    
    func refreshView() {
        let dayOfTrade: String = MarketHelper.nextDayOfTrade()
        let text: String? = dateFormatter.fullTextFromDayOfTrade(dayOfTrade)
        if let quote: Quote = quote {
            symbolLabel.text = quote.symbol
            nameLabel.text = quote.name
            priceLabel.text = numberFormatter.priceFromNumber(quote.price)
            changeLabel.text = changeFormatter.textFromQuote(quote)
            changeLabel.textColor = UIColor.colorForChange(quote.priceChange)
            detailsView.hidden = true
            stockView.hidden = false
            submitButton.hidden = false
        }
        else {
            detailsLabel.text = "Search for a stock to trade on"
            dayOfTradeLabel.text = text!
            detailsView.hidden = false
            stockView.hidden = true
            submitButton.hidden = true
        }
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return count(searchBar.text) + count(text) - range.length <= 5;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if isValidSymbol(searchText) {
            let symbol: String = searchText.uppercaseString
            let requestNumber: UInt = ++self.requestNumber
            FinanceClient.fetchQuoteForSymbol(symbol, block: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if requestNumber == self.requestNumber {
                    self.quote = nil
                    if let data: NSData = data {
                        let quotes: Array<Quote> = Quote.fromData(data)
                        if let quote = quotes.first {
                            self.quote = quote
                        }
                        if let error: NSError = error {
                            println("Error \(error) \(error.userInfo)")
                        }
                    }
                    self.refreshView()
                }
            })
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func isValidSymbol(text: String) -> Bool {
        if text.hasPrefix("^") {
            return false
        }
        if disabledSymbols.containsObject(text.uppercaseString) {
            return false
        }
        return true
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == actionSheet.destructiveButtonIndex {
            if let quote: Quote = self.quote {
                if let symbol: String = quote.symbol {
                    ParseClient.setNextPick(symbol, block: { (succeeded: Bool, error: NSError?) -> Void in
                        if succeeded {
                            NSNotificationCenter.defaultCenter().postNotificationName(Notification.NextPickUpdated.description, object: nil)
                            self.navigationController!.popViewControllerAnimated(true)
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func onSubmitButtonTouched(sender: AnyObject) {
        let dateText: String? = dateFormatter.fullTextFromDayOfTrade(MarketHelper.nextDayOfTrade())
        let title: String = "Shares will be purchased for the opening price and sold at market close. All trades are final at 6:00 a.m. eastern time on \(dateText!)."
        let actionSheet: UIActionSheet = UIActionSheet(title: title, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Confirm")
        actionSheet.showInView(view)
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
}




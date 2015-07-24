//
//  PickViewController.swift
//  DayTrades
//
//  Created by Jason Wells on 7/12/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class PickViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var securityView: UIView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var dayOfTradeLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var disclaimerLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    let disabledSymbols: NSArray = NSBundle.mainBundle().objectForInfoDictionaryKey("Disabled symbols") as! NSArray
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    let numberFormatter: NSNumberFormatter = NSNumberFormatter()
    
    var quote: Quote?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let backgroundImage: UIImage = UIImage(named: "background-2.jpg") {
            view.backgroundColor = UIColor(patternImage: backgroundImage)
        }
        detailsView.backgroundColor = UIColor.translucentColor()
        securityView.backgroundColor = UIColor.translucentColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshView()
    }
    
    func refreshView() {
        let dayOfTrade: String = MarketHelper.nextDayOfTrade()
        let text: String? = dateFormatter.fullTextFromDayOfTrade(dayOfTrade)
        if let quote: Quote = quote {
            disclaimerLabel.text = "The listed security will be purchased for the full value of your account at the opening price and sold at market close on \(text!)."
            symbolLabel.text = quote.symbol
            nameLabel.text = quote.name
            priceLabel.text = numberFormatter.priceFromNumber(NSNumber(double: quote.price))
            detailsView.hidden = true
            securityView.hidden = false
        }
        else {
            detailsLabel.text = "Choose a security to buy on"
            dayOfTradeLabel.text = text!
            securityView.hidden = true
            detailsView.hidden = false
        }
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return count(searchBar.text) + count(text) - range.length <= 5;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if isValidSymbol(searchText) {
            let symbols: Set<String> = ["\(searchText.uppercaseString)"]
            FinanceClient.fetchQuotesForSymbols(symbols, block: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                self.quote = nil
                if let data: NSData = data {
                    let quotes: Array<Quote> = Quote.fromData(data)
                    if let quote = quotes.first {
                        if quote.symbol == searchBar.text.uppercaseString {
                            self.quote = quote
                        }
                    }
                }
                if let error: NSError = error {
                    println("Error \(error) \(error.userInfo)")
                }
                self.refreshView()
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
    
    @IBAction func onSubmitButtonTouched(sender: AnyObject) {
        if let quote: Quote = self.quote {
            if let symbol: String = quote.symbol {
                submitButton.enabled = false
                ParseClient.setNextPick(symbol, block: { (object: PFObject?, error: NSError?) -> Void in
                    if let nextPick: Pick = object as? Pick {
                        NSNotificationCenter.defaultCenter().postNotificationName(Notification.NextPickUpdated.description, object: nil)
                        self.submitButton.enabled = true
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            }
        }
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
}




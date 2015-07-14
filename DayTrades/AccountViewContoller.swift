//
//  AccountViewContoller.swift
//  DayTrades
//
//  Created by Jason Wells on 7/12/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PickViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var picksLabel: UILabel!
    @IBOutlet weak var nextPickLabel: UILabel?
    @IBOutlet weak var nextPickButton: UIButton?
    @IBOutlet weak var winnersBarView: SingleBarView!
    @IBOutlet weak var losersBarView: SingleBarView!
    
    let headerHeight: CGFloat = 22
    let cellHeight: CGFloat = 65
    let cellIdentifier: String = "PickCell"
    let numberFormatter: NSNumberFormatter = NSNumberFormatter()
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    
    var picks: Array<Pick> = Array()
    var account: Account?
    var nextPick: Pick?
    var currentPick: Pick?
    var quote: Quote?
    var quoteTimer: NSTimer?
    
    var lastPrice: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if navigationController != nil {
            navigationController!.navigationBar.barStyle = UIBarStyle.Black
            navigationController!.navigationBar.translucent = true
            navigationController!.navigationBar.tintColor = UIColor .whiteColor()
        }
        if let backgroundImage: UIImage = UIImage(named: "background-1.jpg") {
            view.backgroundColor = UIColor(patternImage: backgroundImage)
        }
        
        nameLabel.text = nil
        valueLabel.text = nil
        picksLabel.text = nil
        nextPickLabel?.text = nil
        nextPickButton?.hidden = true
        winnersBarView.barColor = UIColor.greenColor()
        losersBarView.barColor = UIColor.redColor()
        
        let accountCell = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.registerNib(accountCell, forCellReuseIdentifier: cellIdentifier)
        tableView.allowsSelection = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationBecameActive"), name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationBecameInactive"), name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        fetchAccount()
        quoteTimer?.invalidate()
        quoteTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("fetchQuote"), userInfo: nil, repeats: true)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        winnersBarView.resetView()
        losersBarView.resetView()
        quoteTimer?.invalidate()
    }
    
    func applicationBecameActive() {
        println("application became active")
        fetchAccount()
        quoteTimer?.invalidate()
        quoteTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("fetchQuote"), userInfo: nil, repeats: true)
    }
    
    func applicationBecameInactive() {
        println("application became inactive")
        winnersBarView.resetView()
        losersBarView.resetView()
        quoteTimer?.invalidate()
    }
    
    func fetchAccount() {
        account?.fetchInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
            if error == nil && object != nil {
                self.account = object as! Account?
                self.fetchPicks()
            }
            else {
                println("Error \(error) \(error!.userInfo)")
            }
        })
    }
    
    func refreshView() {
        if account != nil {
            nameLabel.text = account?.user.username
            valueLabel.text = numberFormatter.currencyFromNumber(NSNumber(double: account!.value))
        
            let count: UInt = account!.winners + account!.losers;
            if count == 0 {
                picksLabel.text = "No Picks"
            }
            else {
                if count == 1 {
                    picksLabel.text = "\(count) Pick"
                }
                else {
                    picksLabel.text = "\(count) Picks"
                }
                winnersBarView.value = account!.winners
                winnersBarView.total = count
                winnersBarView.animate(1)
                losersBarView.value = account!.losers
                losersBarView.total = count
                losersBarView.animate(1)
            }
            refreshNextPickView()
            tableView.reloadData()
        }
    }
    
    func refreshNextPickView() {
        if nextPick != nil {
            nextPickLabel?.text = "Next Pick: \(nextPick!.symbol)"
            nextPickButton?.setTitle("Remove", forState: UIControlState.Normal)
        }
        else {
            nextPickLabel?.text = nil
            nextPickButton?.setTitle("Set Next", forState: UIControlState.Normal)
        }
        nextPickButton?.hidden = false
    }
    
    func fetchQuote() {
        if currentPick != nil {
            let symbols: Set<String> = ["\(currentPick!.symbol)"]
            FinanceClient.fetchQuotesForSymbols(symbols, block: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if error == nil {
                    let quotes: Array<Quote> = Quote.fromData(data)
                    if quotes.count == 1 {
                        self.quote = quotes.first
                        self.tableView.reloadData()
                    }
                }
                else {
                    println("Error \(error) \(error!.userInfo)")
                }
            })
        }
    }
    
    func fetchPicks() {
        if account != nil {
            ParseClient.fetchPicksForAccount(account!, limit: 10, skip: 0, block: { (objects: [AnyObject]?,error:  NSError?) -> Void in
                if error == nil && objects != nil {
                    if let picks: Array<Pick> = objects as? Array<Pick> {
                        self.refreshPicks(picks)
                        self.fetchQuote()
                        self.enableInfiniteScroll()
                    }
                }
                else {
                    println("Error \(error) \(error!.userInfo)")
                }
            })
        }
    }
    
    func refreshPicks(picks: Array<Pick>) {
        let lastDayOfTrade: String? = MarketHelper.lastDayOfTrade()
        let nextDayOfTrade: String? = MarketHelper.nextDayOfTrade()
        
        nextPick = nil;
        currentPick = nil;
        self.picks.removeAll()
        
        for pick: Pick in picks {
            if !pick.processed && lastDayOfTrade == pick.dayOfTrade {
                currentPick = pick;
            }
            else if nextDayOfTrade == pick.dayOfTrade {
                nextPick = pick;
            }
            else {
                self.picks.append(pick)
            }
        }
        refreshView()
    }
    
    func updateNextPick(pick: Pick?) {
        nextPick = pick
        refreshNextPickView()
    }
    
    func flashTextColor(color: UIColor, label: UILabel) {
        UIView.transitionWithView(label, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            label.textColor = color
            }) { (finished: Bool) -> Void in
                label.textColor = UIColor.whiteColor()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return picks.count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: PickCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PickCell
        cell.resetView()
        
        if indexPath.section == 0 {
            if currentPick != nil {
                cell.dateLabel.text = dateFormatter.shortFromDayOfTrade(currentPick!.dayOfTrade)
                cell.symbolLabel.text = currentPick!.symbol
                if account != nil && quote != nil && quote!.open > 0 {
                    let priceChange: Double = quote!.price - quote!.open
                    let percentChange: Double = priceChange / quote!.open * 100
                    let estimatedValue: Double = account!.value + (account!.value * percentChange / 100);
                    cell.openLabel.text = numberFormatter.priceFromNumber(quote!.open)
                    cell.closeLabel.text = numberFormatter.priceFromNumber(quote!.price)
                    cell.buyLabel.text = "BUY"
                    cell.valueLabel.text = "\(numberFormatter.currencyFromNumber(estimatedValue)) (Est)"
                    cell.changeLabel.text = ChangeFormatter.stringFromChange(priceChange, percentChange: percentChange)
                    cell.changeLabel.textColor = UIColor.colorForChange(priceChange)
                    if lastPrice != 0 && lastPrice != quote!.price {
                        let color: UIColor = UIColor.colorForChange(quote!.price - lastPrice)
                        flashTextColor(color, label: cell.closeLabel)
                        flashTextColor(color, label: cell.valueLabel)
                    }
                    lastPrice = quote!.price
                }
            }
            else if MarketHelper.isMarketClosed() {
                cell.openLabel.text = "Market Closed"
            }
        }
        else if indexPath.section == 1 && indexPath.row < picks.count {
            let pick: Pick = picks[indexPath.row]
            cell.dateLabel.text = dateFormatter.shortFromDayOfTrade(pick.dayOfTrade)
            cell.symbolLabel.text = pick.symbol
            cell.openLabel.text = numberFormatter.priceFromNumber(pick.open)
            cell.closeLabel.text = numberFormatter.priceFromNumber(pick.close)
            cell.buyLabel.text = "BUY"
            cell.sellLabel.text = "SELL"
            cell.valueLabel.text = numberFormatter.currencyFromNumber(pick.value + pick.change)
            cell.changeLabel.text = ChangeFormatter.stringFromPick(pick)
            cell.changeLabel.textColor = UIColor.colorForChange(pick.change)
            cell.openLabel.textColor = UIColor.whiteColor()
            cell.closeLabel.textColor = UIColor.whiteColor()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return max(tableView.frame.size.height - 2 * headerHeight - (CGFloat(picks.count) * cellHeight), 0)
        }
        return cellHeight
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Current Pick"
        }
        if section == 1 {
            return "Previous Picks"
        }
        return nil
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView: UITableViewHeaderFooterView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = UIColor.darkGrayColor()
            headerView.textLabel.textColor = UIColor.whiteColor()
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let y: CGFloat = tableView.contentSize.height - tableView.bounds.size.height + tableView.infiniteScrollingView.frame.size.height + 1
        if tableView.contentOffset.y >= y {
            tableView.contentOffset = CGPointMake(0, y)
        }
    }
    
    func enableInfiniteScroll() {
        tableView.addInfiniteScrollingWithActionHandler { () -> Void in
            if self.account != nil {
                var skip: Int = self.picks.count
                if self.nextPick != nil { skip++ }
                if self.currentPick != nil { skip++ }
                ParseClient.fetchPicksForAccount(self.account!, limit: 10, skip: skip, block: { (objects: [AnyObject]?, error: NSError?) -> Void in
                    if error == nil {
                        if objects != nil && objects!.count > 0 {
                            self.picks += objects as! Array<Pick>
                            self.tableView.reloadData()
                        }
                    }
                    else {
                        println("Error \(error) \(error!.userInfo)")
                    }
                    self.tableView.infiniteScrollingView.stopAnimating()
                })
            }
        }
        tableView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        tableView.infiniteScrollingView.backgroundColor = UIColor.translucentColor()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "ShowPickSegue" {
            let nextDayOfTrade:String? = MarketHelper.nextDayOfTrade()
            if nextPick != nil && nextPick?.dayOfTrade == nextDayOfTrade {
                nextPick?.deleteInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                    if succeeded {
                        self.nextPick = nil
                        self.refreshNextPickView()
                    }
                })
                return false
            }
        }
        return true
    }
                
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPickSegue" {
            if let pickViewController: PickViewController = segue.destinationViewController as? PickViewController {
                pickViewController.delegate = self
                pickViewController.account = account;
            }
        }
    }

    @IBAction func onLogOutButtonTouched(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(LogOutNotification, object: nil)
    }
    
}

//
//  AccountViewContoller.swift
//  DayTrades
//
//  Created by Jason Wells on 7/12/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var picksLabel: UILabel!
    @IBOutlet weak var nextPickLabel: UILabel!
    @IBOutlet weak var nextPickButton: UIButton!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var winnersBarView: SingleBarView!
    @IBOutlet weak var losersBarView: SingleBarView!
    
    let headerHeight: CGFloat = 20
    let cellHeight: CGFloat = 60
    let cellIdentifier: String = "PickCell"
    let numberFormatter: NSNumberFormatter = NSNumberFormatter()
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    
    var picks: Array<Pick> = Array()
    var nextPick: Pick?
    var currentPick: Pick?
    var quote: Quote?
    var quoteTimer: NSTimer?
    var lastPrice: Double = 0
    
    var account: Account? {
        didSet {
            fetchPicks()
            fetchAwards()
            if let account: Account = self.account {
                if account.user.objectId == PFUser.currentUser()?.objectId {
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("fetchNextPick"), name: Notification.NextPickUpdated.description, object: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let backgroundImage: UIImage = UIImage(named: "background-1.jpg") {
            view.backgroundColor = UIColor(patternImage: backgroundImage)
        }
        
        nameLabel.text = nil
        valueLabel.text = nil
        picksLabel.text = nil
        nextPickLabel?.text = nil
        nextPickButton?.hidden = true
        nextPickButton?.layer.cornerRadius = 4
        winnersBarView.barColor = UIColor.increaseColor()
        losersBarView.barColor = UIColor.decreaseColor()
        
        let accountCell = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.registerNib(accountCell, forCellReuseIdentifier: cellIdentifier)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationBecameActive"), name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationBecameInactive"), name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        quoteTimer?.invalidate()
        quoteTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("fetchQuote"), userInfo: nil, repeats: true)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        quoteTimer?.invalidate()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "ShowPickSegue" {
            if let nextPick: Pick = self.nextPick {
                if nextPick.dayOfTrade == MarketHelper.nextDayOfTrade() {
                    ParseClient.deletePick(nextPick, block: { (succeeded: Bool, error: NSError?) -> Void in
                        if succeeded {
                            self.nextPick = nil
                            self.refreshNextPickView()
                        }
                    })
                    return false
                }
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowStockSegue" {
            if let stockViewController: StockViewController = segue.destinationViewController as? StockViewController {
                if let indexPath: NSIndexPath = tableView.indexPathForSelectedRow() {
                    if indexPath.section == 0 {
                        if let currentPick = self.currentPick {
                            stockViewController.symbol = currentPick.symbol
                        }
                    }
                    else if indexPath.section == 1 && indexPath.row < picks.count {
                        let pick: Pick = picks[indexPath.row]
                        stockViewController.symbol = pick.symbol
                    }
                }
            }
        }
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
    
    func refreshView() {
        if let account: Account = self.account {
            nameLabel.text = account.user.username
            valueLabel.text = numberFormatter.currencyFromNumber(NSNumber(double: account.value))
        
            let count: UInt = account.winners + account.losers;
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
                winnersBarView.value = account.winners
                winnersBarView.total = count
                winnersBarView.animate(1)
                losersBarView.value = account.losers
                losersBarView.total = count
                losersBarView.animate(1)
            }
            tableView.reloadData()
        }
    }
    
    func refreshNextPickView() {
        if let account: Account = self.account {
            if account.user.objectId == PFUser.currentUser()?.objectId {
                if let nextPick: Pick = self.nextPick {
                    nextPickLabel?.text = "Next Pick: \(nextPick.symbol)"
                    nextPickButton?.setTitle("Remove", forState: UIControlState.Normal)
                }
                else {
                    nextPickLabel?.text = nil
                    nextPickButton?.setTitle("Set Next", forState: UIControlState.Normal)
                }
                nextPickButton?.hidden = false
            }
        }
    }
    
    func refreshAwardView(images: Array<UIImage?>) {
        if images.count > 0 {
            if let image: UIImage = images[0] {
                leftImageView.image = image
            }
        }
        if images.count > 1 {
            if let image: UIImage = images[1] {
                rightImageView.image = image
            }
        }
    }
    
    func fetchAccount() {
        if account != nil {
            ParseClient.refreshAccount(account!, block: { (object: PFObject?, error: NSError?) -> Void in
                if let object: PFObject = object {
                    self.account = object as? Account
                    self.fetchAwards()
                    self.fetchPicks()
                }
                if let error: NSError = error {
                    println("Error \(error) \(error.userInfo)")
                }
            })
        }
    }
    
    func fetchAwards() {
        var images: Array<UIImage?> = Array()
        ParseClient.fetchAccountsSortedByColumn("value", limit: 3, skip: 0) { (objects: [AnyObject]?, error: NSError?) -> Void in
            if let accounts: Array<Account> = objects as? Array<Account> {
                if accounts.count > 0 && accounts[0].objectId == self.account?.objectId {
                    images.insert(UIImage(named: "trophy-1.png")?.tintedWithGoldColor(), atIndex: 0)
                }
                else if accounts.count > 1 && accounts[1].objectId == self.account?.objectId {
                    images.insert(UIImage(named: "trophy-2.png")?.tintedWithSilverColor(), atIndex: 0)
                }
                else if accounts.count > 2 && accounts[2].objectId == self.account?.objectId {
                    images.insert(UIImage(named: "trophy-3.png")?.tintedWithBronzeColor(), atIndex: 0)
                }
                self.refreshAwardView(images)
            }
            if let error: NSError = error {
                println("Error \(error) \(error.userInfo)")
            }
        }
        ParseClient.fetchAccountsSortedByColumn("winners", limit: 3, skip: 0) { (objects: [AnyObject]?, error: NSError?) -> Void in
            if let accounts: Array<Account> = objects as? Array<Account> {
                if accounts.count > 0 && accounts[0].objectId == self.account?.objectId {
                    images.append(UIImage(named: "ribbon-1.png")?.tintedWithBlueColor())
                }
                else if accounts.count > 1 && accounts[1].objectId == self.account?.objectId {
                    images.append(UIImage(named: "ribbon-2.png")?.tintedWithRedColor())
                }
                else if accounts.count > 2 && accounts[2].objectId == self.account?.objectId {
                    images.append(UIImage(named: "ribbon-3.png")?.tintedWithWhiteColor())
                }
                self.refreshAwardView(images)
            }
            if let error: NSError = error {
                println("Error \(error) \(error.userInfo)")
            }
        }
    }
    
    func fetchNextPick() {
        ParseClient.fetchNextPick { (object: PFObject?, error: NSError?) -> Void in
            if let nextPick: Pick = object as? Pick {
                self.nextPick = nextPick
                self.refreshNextPickView()
            }
        }
    }
    
    func fetchPicks() {
        if let account: Account = self.account {
            ParseClient.fetchPicksForAccount(account, limit: 10, skip: 0, block: { (objects: [AnyObject]?,error:  NSError?) -> Void in
                if let objects: [AnyObject] = objects {
                    if let picks: Array<Pick> = objects as? Array<Pick> {
                        self.sortPicks(picks)
                        self.fetchQuote()
                        self.enableInfiniteScroll()
                    }
                }
                if let error: NSError = error {
                    println("Error \(error) \(error.userInfo)")
                }
            })
        }
    }
    
    func fetchQuote() {
        if currentPick != nil {
            let symbols: Set<String> = ["\(currentPick!.symbol)"]
            FinanceClient.fetchQuotesForSymbols(symbols, block: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if let data: NSData = data {
                    let quotes: Array<Quote> = Quote.fromData(data)
                    if quotes.count == 1 {
                        self.quote = quotes.first
                        self.tableView.reloadData()
                    }
                }
                if let error: NSError = error {
                    println("Error \(error) \(error.userInfo)")
                }
            })
        }
    }
    
    func sortPicks(picks: Array<Pick>) {
        let previousDayOfTrade: String = MarketHelper.previousDayOfTrade()
        let nextDayOfTrade: String = MarketHelper.nextDayOfTrade()
        
        nextPick = nil;
        currentPick = nil;
        self.picks.removeAll()
        
        for pick: Pick in picks {
            if !pick.processed && previousDayOfTrade == pick.dayOfTrade {
                currentPick = pick;
            }
            else if nextDayOfTrade == pick.dayOfTrade {
                nextPick = pick;
            }
            else {
                self.picks.append(pick)
            }
        }
        refreshNextPickView()
        refreshView()
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
            if let currentPick: Pick = self.currentPick {
                cell.dateLabel.text = dateFormatter.pickTextFromDayOfTrade(currentPick.dayOfTrade)
                cell.symbolLabel.text = currentPick.symbol
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
            cell.dateLabel.text = dateFormatter.pickTextFromDayOfTrade(pick.dayOfTrade)
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
            return max(1 + tableView.frame.size.height - (2 * headerHeight) - (CGFloat(picks.count + 1) * cellHeight), 0)
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
            headerView.textLabel.font = UIFont.boldSystemFontOfSize(15)
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.userInteractionEnabled = false
        if indexPath.section == 0 {
            if let currentPick: Pick = self.currentPick {
                cell.userInteractionEnabled = true
            }
        }
        if indexPath.section == 1 {
            cell.userInteractionEnabled = true
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if let currentPick: Pick = self.currentPick {
                performSegueWithIdentifier("ShowStockSegue", sender: nil)
            }
        }
        if indexPath.section == 1 && indexPath.row < picks.count {
            performSegueWithIdentifier("ShowStockSegue", sender: nil)
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
            if let account: Account = self.account {
                var skip: Int = self.picks.count
                if let nextPick = self.nextPick {
                    skip++
                }
                if let currentPick = self.currentPick {
                    skip++
                }
                ParseClient.fetchPicksForAccount(account, limit: 10, skip: skip, block: { (objects: [AnyObject]?, error: NSError?) -> Void in
                    if let objects: [AnyObject] = objects {
                        self.picks += objects as! Array<Pick>
                        self.tableView.reloadData()
                    }
                    if let error: NSError = error {
                        println("Error \(error) \(error.userInfo)")
                    }
                    self.tableView.infiniteScrollingView.stopAnimating()
                })
            }
        }
        tableView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        tableView.infiniteScrollingView.backgroundColor = UIColor.translucentColor()
    }
    
}

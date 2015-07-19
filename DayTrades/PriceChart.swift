//
//  PriceChart.swift
//  DayTrades
//
//  Created by Jason Wells on 7/16/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class PriceChart: CPTGraphHostingView, CPTPlotDataSource {
    
    var plot: CPTTradingRangePlot?
    var plotSpace: CPTXYPlotSpace?
    var quotes: Array<DayQuote> = Array()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.whiteColor()
        
        hostedGraph = CPTXYGraph(frame: frame)
        hostedGraph.paddingLeft = 0
        hostedGraph.paddingTop = 0
        hostedGraph.paddingRight = 0
        hostedGraph.paddingBottom = 0
        hostedGraph.masksToBorder = true
        
        plot = CPTTradingRangePlot(frame: frame)
        plot?.dataSource = self
        plot?.plotStyle = CPTTradingRangePlotStyle.CandleStick
        plot?.increaseFill = CPTFill(color: CPTColor.redColor())
        plot?.decreaseFill = CPTFill(color: CPTColor.greenColor())
        
        plotSpace = hostedGraph.defaultPlotSpace as? CPTXYPlotSpace
        hostedGraph.addPlot(plot, toPlotSpace:hostedGraph.defaultPlotSpace)
    }
    
    func reloadDataForSymbol(symbol: String, start: String, end: String) {
        FinanceClient.fetchDayQuotesForSymbol(symbol, start: start, end: end) { (response: NSURLResponse!, data: NSData!, error: NSError?) -> Void in
            if error == nil {
                let quotes: Array<DayQuote> = DayQuote.fromData(data)
                self.reloadDataForQuotes(quotes)
            }
            else {
                println("Error \(error) \(error!.userInfo)")
            }
        }
    }
    func reloadDataForQuotes(quotes: Array<DayQuote> ) {
        if quotes.count > 0 {
            self.quotes = quotes
            var minRange: Double = DBL_MAX
            var maxRanage: Double = DBL_MIN
            for quote: DayQuote in quotes {
                minRange = min(minRange, quote.open, quote.close, quote.high, quote.low)
                maxRanage = max(maxRanage, quote.open, quote.close, quote.high, quote.low)
            }
            minRange = minRange * 0.995
            maxRanage = maxRanage * 1.005
            plotSpace?.xRange = CPTPlotRange(location: CPTDecimalFromInteger(0), length: CPTDecimalFromInteger(quotes.count))
            plotSpace?.yRange = CPTPlotRange(location: CPTDecimalFromDouble(minRange), length: CPTDecimalFromDouble(maxRanage - minRange))
            hostedGraph.reloadData()
        }
    }
    
    func numberOfRecordsForPlot(plot: CPTPlot!) -> UInt {
        return UInt(quotes.count)
    }
    
    func numberForPlot(plot: CPTPlot!, field fieldEnum: UInt, recordIndex idx: UInt) -> AnyObject! {
        if Int(fieldEnum) == CPTScatterPlotField.X.rawValue {
            return idx
        }
        if (idx > 0) {
            let quote: DayQuote = quotes[Int(idx) - 1]
            if Int(fieldEnum) == CPTTradingRangePlotField.Open.rawValue {
                return quote.open
            }
            if Int(fieldEnum) == CPTTradingRangePlotField.Close.rawValue {
                return quote.close
            }
            if Int(fieldEnum) == CPTTradingRangePlotField.High.rawValue {
                return quote.high
            }
            if Int(fieldEnum) == CPTTradingRangePlotField.Low.rawValue {
                return quote.low
            }
        }
        return nil
    }

}
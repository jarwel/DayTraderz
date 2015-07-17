//
//  PriceChart.swift
//  DayTrades
//
//  Created by Jason Wells on 7/16/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class PriceChart: CPTGraphHostingView, CPTPlotDataSource {
    
    var plotSpace: CPTXYPlotSpace?
    var scatterPlot: CPTScatterPlot?
    var quotes: Array<DayQuote> = Array()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hostedGraph = CPTXYGraph(frame: frame)
        hostedGraph.paddingLeft = 0
        hostedGraph.paddingTop = 0
        hostedGraph.paddingRight = 0
        hostedGraph.paddingBottom = 0
        hostedGraph.masksToBorder = false
        
        scatterPlot = CPTScatterPlot(frame: frame)
        scatterPlot?.dataSource = self
        
        let lineStyle: CPTMutableLineStyle = CPTMutableLineStyle()
        lineStyle.lineColor = CPTColor.greenColor()
        scatterPlot!.dataLineStyle = lineStyle
        
        let areaGradient: CPTGradient = CPTGradient(beginningColor: CPTColor.greenColor(), endingColor: CPTColor.clearColor())
        areaGradient.angle = -90
        scatterPlot?.areaFill = CPTFill(gradient: areaGradient)
        
        plotSpace = hostedGraph.defaultPlotSpace as? CPTXYPlotSpace
        hostedGraph.addPlot(scatterPlot, toPlotSpace:hostedGraph.defaultPlotSpace)
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
        self.quotes = quotes
        var low: Double = DBL_MAX
        var high: Double = DBL_MIN
        for quote: DayQuote in quotes {
            low = min(low, quote.close)
            high = max(high, quote.close)
        }
        plotSpace?.xRange = CPTPlotRange(location: CPTDecimalFromInteger(0), length: CPTDecimalFromInteger(quotes.count))
        plotSpace?.yRange = CPTPlotRange(location: CPTDecimalFromDouble(low), length: CPTDecimalFromDouble(high - low))
        scatterPlot?.areaBaseValue = CPTDecimalFromDouble(low)
        hostedGraph.reloadData()
    }
    
    func numberOfRecordsForPlot(plot: CPTPlot!) -> UInt {
        return UInt(quotes.count)
    }
    
    func numberForPlot(plot: CPTPlot!, field fieldEnum: UInt, recordIndex idx: UInt) -> AnyObject! {
        if Int(fieldEnum) == CPTScatterPlotField.X.rawValue {
            return idx
        }
        let quote: DayQuote = quotes[Int(idx)]
        return quote.close
    }

}
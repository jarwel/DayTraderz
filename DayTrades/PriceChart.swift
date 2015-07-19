//
//  PriceChart.swift
//  DayTrades
//
//  Created by Jason Wells on 7/16/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class PriceChart: CPTGraphHostingView, CPTPlotDataSource {
    
    let axisOffset:Int = 6
    
    var plot: CPTTradingRangePlot?
    var plotSpace: CPTXYPlotSpace?
    var xAxis: CPTXYAxis?
    var yAxis: CPTXYAxis?
    
    var quotes: Array<DayQuote> = Array()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.whiteColor()
        
        hostedGraph = CPTXYGraph(frame: frame)
        hostedGraph.paddingLeft = 0
        hostedGraph.paddingTop = 0
        hostedGraph.paddingRight = 0
        hostedGraph.paddingBottom = 30
        hostedGraph.masksToBorder = false
        
        hostedGraph.plotAreaFrame.masksToBorder = false
        
        let plot: CPTTradingRangePlot = CPTTradingRangePlot(frame: frame)
        plot.dataSource = self
        plot.plotStyle = CPTTradingRangePlotStyle.CandleStick
        plot.increaseFill = CPTFill(color: CPTColor.greenColor())
        plot.decreaseFill = CPTFill(color: CPTColor.redColor())
        hostedGraph.addPlot(plot, toPlotSpace:hostedGraph.defaultPlotSpace)
        
        plotSpace = hostedGraph.defaultPlotSpace as? CPTXYPlotSpace
        
        let axisSet: CPTXYAxisSet = hostedGraph.axisSet as! CPTXYAxisSet
        xAxis = axisSet.xAxis
        yAxis?.delegate = self
        yAxis = axisSet.yAxis
    }
    
    func reloadDataForSymbol(symbol: String, start: String, end: String) {
        FinanceClient.fetchDayQuotesForSymbol(symbol, start: start, end: end) { (response: NSURLResponse!, data: NSData!, error: NSError?) -> Void in
            if error == nil {
                let quotes: Array<DayQuote> = DayQuote.fromData(data).reverse()
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
            var maxRange: Double = DBL_MIN
            for quote: DayQuote in quotes {
                let date:String = quote.date!
                
                minRange = min(minRange, quote.open, quote.close, quote.high, quote.low)
                maxRange = max(maxRange, quote.open, quote.close, quote.high, quote.low)
            }
            
            xAxis?.orthogonalCoordinateDecimal = NSNumber(double: minRange).decimalValue
            yAxis?.orthogonalCoordinateDecimal = NSNumber(integer: quotes.count + axisOffset).decimalValue
            yAxis?.preferredNumberOfMajorTicks = 5
            
            let gridLineStyle: CPTMutableLineStyle = CPTMutableLineStyle()
            gridLineStyle.dashPattern = [2, 2]
            gridLineStyle.lineColor = CPTColor.lightGrayColor()
            yAxis?.majorGridLineStyle = gridLineStyle
            
            minRange = minRange * 0.995
            maxRange = maxRange * 1.005
            plotSpace?.xRange = CPTPlotRange(location: CPTDecimalFromInteger(0), length: CPTDecimalFromInteger(quotes.count + axisOffset))
            plotSpace?.yRange = CPTPlotRange(location: CPTDecimalFromDouble(minRange), length: CPTDecimalFromDouble(maxRange - minRange))
            configureAxis()
            hostedGraph.reloadData()
        }
    }
    
    func configureAxis() {
        xAxis?.labelingPolicy = CPTAxisLabelingPolicy.None
        yAxis?.labelingPolicy = CPTAxisLabelingPolicy.Automatic
        
        let textStyle: CPTMutableTextStyle = CPTMutableTextStyle()
        textStyle.color = CPTColor.blueColor()
        
        var tickLocations: Set<Int> = Set()
        var axisLabels: Set<CPTAxisLabel> = Set()
        
        for index: Int in 0...quotes.count - 1 {
            let quote: DayQuote = quotes[index]
            let date: String = quote.date!
            if date.rangeOfString("-15-") != nil {
                let axisLabel: CPTAxisLabel = CPTAxisLabel(text: date, textStyle: CPTTextStyle())
                axisLabel.tickLocation = NSNumber(integer: index).decimalValue
                axisLabels.insert(axisLabel)
                tickLocations.insert(index)
            }
            
        }
        
        xAxis?.majorTickLocations = tickLocations
        xAxis?.axisLabels = axisLabels
        
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
//
//  PriceChart.swift
//  DayTrades
//
//  Created by Jason Wells on 7/16/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class PriceChart: CPTGraphHostingView, CPTPlotDataSource {
    
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    
    var plot: CPTTradingRangePlot?
    var plotSpace: CPTXYPlotSpace?
    var axisSet: CPTXYAxisSet?
    
    var quotes: Array<DayQuote> = Array()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.whiteColor()
        
        hostedGraph = CPTXYGraph(frame: frame)
        hostedGraph.paddingLeft = 0
        hostedGraph.paddingTop = 0
        hostedGraph.paddingRight = 0
        hostedGraph.paddingBottom = 30
        hostedGraph.plotAreaFrame.masksToBorder = false
        hostedGraph.plotAreaFrame.paddingBottom = 5
        
        let plot: CPTTradingRangePlot = CPTTradingRangePlot(frame: frame)
        plot.dataSource = self
        plot.plotStyle = CPTTradingRangePlotStyle.CandleStick
        plot.increaseFill = CPTFill(color: CPTColor.greenColor())
        plot.decreaseFill = CPTFill(color: CPTColor.redColor())
        hostedGraph.addPlot(plot, toPlotSpace:hostedGraph.defaultPlotSpace)
        
        plotSpace = hostedGraph.defaultPlotSpace as? CPTXYPlotSpace
        axisSet = hostedGraph.axisSet as? CPTXYAxisSet
        
        let gridLineStyle: CPTMutableLineStyle = CPTMutableLineStyle()
        gridLineStyle.dashPattern = [2, 2]
        gridLineStyle.lineColor = CPTColor.lightGrayColor()
 
        axisSet?.xAxis.labelingPolicy = CPTAxisLabelingPolicy.None
        axisSet?.xAxis.majorGridLineStyle = gridLineStyle
        
        axisSet?.yAxis.labelingPolicy = CPTAxisLabelingPolicy.Automatic
        axisSet?.yAxis.majorGridLineStyle = gridLineStyle
        axisSet?.yAxis.preferredNumberOfMajorTicks = 5
    }
    
    func reloadDataForQuotes(quotes: Array<DayQuote> ) {
        if quotes.count > 0 {
            self.quotes = quotes
            
            var minRange: Double = DBL_MAX
            var maxRange: Double = DBL_MIN
            var majorTickLocations: Set<Int> = Set()
            var axisLabels: Set<CPTAxisLabel> = Set()
            
            for index: Int in 1...quotes.count {
                let quote: DayQuote = quotes[index - 1]
                minRange = min(minRange, quote.open, quote.close, quote.high, quote.low)
                maxRange = max(maxRange, quote.open, quote.close, quote.high, quote.low)
                if index == 5 || (index - 5) % 10 == 0 {
                    let text: String? = dateFormatter.chartTextFromDayOfTrade(quote.date)
                    let axisLabel: CPTAxisLabel = CPTAxisLabel(text: text, textStyle: CPTTextStyle())
                    axisLabel.tickLocation = NSNumber(integer: index).decimalValue
                    axisLabels.insert(axisLabel)
                    majorTickLocations.insert(index)
                }
            }
            
            minRange = minRange * 0.995
            maxRange = maxRange * 1.005
            plotSpace?.xRange = CPTPlotRange(location: CPTDecimalFromInteger(0), length: CPTDecimalFromInteger(quotes.count + 6))
            plotSpace?.yRange = CPTPlotRange(location: CPTDecimalFromDouble(minRange), length: CPTDecimalFromDouble(maxRange - minRange))
            
            axisSet?.xAxis.orthogonalCoordinateDecimal = NSNumber(double: minRange).decimalValue
            axisSet?.xAxis.majorTickLocations = majorTickLocations
            axisSet?.xAxis.axisLabels = axisLabels
            
            axisSet?.yAxis.orthogonalCoordinateDecimal = NSNumber(integer: quotes.count + 6).decimalValue
            
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
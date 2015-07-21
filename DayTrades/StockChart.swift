//
//  StockChart.swift
//  DayTrades
//
//  Created by Jason Wells on 7/16/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class StockChart: CPTGraphHostingView, CPTPlotDataSource, CPTAxisDelegate {
    
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    let gridLineStyle: CPTLineStyle
    let labelTextStyle: CPTTextStyle
    
    var plot: CPTTradingRangePlot?
    var plotSpace: CPTXYPlotSpace?
    var axisSet: CPTXYAxisSet?
    
    var quotes: Array<DayQuote> = Array()
    
    required init(coder aDecoder: NSCoder) {
        
        let gridLineStyle: CPTMutableLineStyle = CPTMutableLineStyle()
        gridLineStyle.dashPattern = [2, 2]
        gridLineStyle.lineColor = CPTColor.lightGrayColor()
        self.gridLineStyle = gridLineStyle
        
        let labelTextStyle: CPTMutableTextStyle = CPTMutableTextStyle()
        labelTextStyle.color = CPTColor.whiteColor()
        self.labelTextStyle = labelTextStyle
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        hostedGraph = CPTXYGraph(frame: frame)
        hostedGraph.backgroundColor = UIColor.translucentColor().CGColor
        hostedGraph.plotAreaFrame.masksToBorder = false
        hostedGraph.plotAreaFrame.fill = CPTFill(color: CPTColor.whiteColor())
        
        let plot: CPTTradingRangePlot = CPTTradingRangePlot(frame: frame)
        plot.dataSource = self
        plot.plotStyle = CPTTradingRangePlotStyle.CandleStick
        plot.increaseFill = CPTFill(color: CPTColor.greenColor())
        plot.decreaseFill = CPTFill(color: CPTColor.redColor())
        hostedGraph.addPlot(plot, toPlotSpace:hostedGraph.defaultPlotSpace)
        
        plotSpace = hostedGraph.defaultPlotSpace as? CPTXYPlotSpace
        
        axisSet = hostedGraph.axisSet as? CPTXYAxisSet
        axisSet?.xAxis.delegate = self
        axisSet?.yAxis.delegate = self
        
        axisSet?.xAxis.labelingPolicy = CPTAxisLabelingPolicy.Automatic
        axisSet?.xAxis.majorGridLineStyle = gridLineStyle
        
        axisSet?.yAxis.labelingPolicy = CPTAxisLabelingPolicy.Automatic
        axisSet?.yAxis.majorGridLineStyle = gridLineStyle
        axisSet?.yAxis.tickDirection = CPTSign.Positive
    }
    
    func reloadDataForQuotes(quotes: Array<DayQuote> ) {
        if quotes.count > 0 {
            self.quotes = quotes
            
            var minRange: Double = DBL_MAX
            var maxRange: Double = DBL_MIN
            for quote: DayQuote in quotes {
                minRange = min(minRange, quote.open, quote.close, quote.high, quote.low)
                maxRange = max(maxRange, quote.open, quote.close, quote.high, quote.low)
            }
            minRange = minRange * 0.995
            maxRange = maxRange * 1.005
            
            plotSpace?.xRange = CPTPlotRange(location: CPTDecimalFromInteger(0), length: CPTDecimalFromInteger(quotes.count))
            plotSpace?.yRange = CPTPlotRange(location: CPTDecimalFromDouble(minRange), length: CPTDecimalFromDouble(maxRange - minRange))
            
            axisSet?.xAxis.orthogonalCoordinateDecimal = NSNumber(double: minRange).decimalValue
            axisSet?.yAxis.orthogonalCoordinateDecimal = NSNumber(integer: quotes.count).decimalValue
            
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
    
    func axis(axis: CPTAxis!, shouldUpdateAxisLabelsAtLocations locations: Set<NSObject>!) -> Bool {
        
        if axis == axisSet?.xAxis {
            var axisLabels: Set<NSObject> = Set()
            for location: NSObject in locations {
                let tickLocation: NSDecimalNumber = location as! NSDecimalNumber
                if tickLocation.integerValue > 0 && tickLocation.integerValue < quotes.count + 1 {
                    let quote: DayQuote = quotes[tickLocation.integerValue - 1]
                    if let text: String? = dateFormatter.chartTextFromDayOfTrade(quote.date) {
                        let axisLabel: CPTAxisLabel = CPTAxisLabel(text: text, textStyle: labelTextStyle)
                        axisLabel.tickLocation = tickLocation.decimalValue
                        axisLabel.offset = 6
                        axisLabels.insert(axisLabel)
                    }
                }
            }
            axis.axisLabels = axisLabels
            hostedGraph.paddingTop = 5
            hostedGraph.paddingBottom = 30
        }
        
        if axis == axisSet?.yAxis {
            var axisLabels: Set<NSObject> = Set()
            var offset: CGFloat = 0
            for location: NSObject in locations {
                let tickLocation: NSDecimalNumber = location as! NSDecimalNumber
                if let text: String = axis.labelFormatter.stringForObjectValue(tickLocation) {
                    offset = CGFloat(count(text))
                    let axisLabel: CPTAxisLabel = CPTAxisLabel(text: text, textStyle: labelTextStyle)
                    axisLabel.tickLocation = tickLocation.decimalValue
                    axisLabel.offset = offset
                    axisLabels.insert(axisLabel)
                }
            }
            axis.axisLabels = axisLabels
            hostedGraph.paddingLeft = 5
            hostedGraph.paddingRight = 9 * offset
        }
    
        return false
    }

}
//
//  MultiLineChartTableViewCell.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/23/17.
//

import UIKit
import MiningPoolHub_Swift
import SwiftCharts
import DateToolsSwift

class MultiLineChartTableViewCell: PulsableTableViewCell {

    fileprivate var chart: Chart?
    
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(walletData: MphsWalletData, currency: MphsCurrency, conversionData: MphsConversionData, autoExchange: MphDomain) {
        self.chart?.clearView()
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        let conversion = conversionData.conversion(for: autoExchange)
        let exchangeValue = conversion.conversion(for: currency) ?? 0.0
        
        var index = 0
        let formatter = DateFormatter(withFormat: "yyyy-MM-dd", locale: "UCT")
        let shortFormatter = DateFormatter(withFormat: "dd", locale: "UCT")
        let chartPoints = walletData.earning_history.reversed().map { (credit: MphRecentCredit) -> ChartPoint in
            index += 1
            
            if let date = formatter.date(from: credit.date) {
                return ChartPoint(x: ChartAxisValueString(shortFormatter.string(from: date), order: index, labelSettings: ChartLabelSettings(font: ExamplesDefaults.labelFont)), y: ChartAxisValueDouble(credit.amount*exchangeValue))
            }
            return ChartPoint(x: ChartAxisValueString("N/A", order: index), y: ChartAxisValueDouble(credit.amount*exchangeValue))
        }
        
        //Add additional xValues for graph padding
        var xValues = chartPoints.map {$0.x}
        index+=1; xValues.append(ChartAxisValueString("", order: index, labelSettings: ChartLabelSettings(font: ExamplesDefaults.labelFont)))
        index+=1; xValues.append(ChartAxisValueString("", order: index, labelSettings: ChartLabelSettings(font: ExamplesDefaults.labelFont)))
        
        //let xValues = ChartAxisValuesStaticGenerator.generateXAxisValuesWithChartPoints(chartPoints, minSegmentCount: 12, maxSegmentCount: 12, multiple: 1, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: false)
        let maxYCredit = walletData.earning_history.max { (c1, c2) -> Bool in
            return c1.amount < c2.amount
        }
        let minYAmountValue = (maxYCredit?.amount ?? 10)*exchangeValue*0.1
        let yValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(chartPoints, minSegmentCount: minYAmountValue, maxSegmentCount: 500, multiple: 1, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: true)
        
        let xModel = ChartAxisModel(axisValues: xValues)
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Value in "+currency.description(), settings: labelSettings.defaultVertical()))
        let chartFrame = ExamplesDefaults.chartFrame(containerView.bounds)
        
        var chartSettings = ExamplesDefaults.chartSettings // for now no zooming and panning here until ChartShowCoordsLinesLayer is improved to not scale the lines during zooming.
        chartSettings.trailing = 20
        chartSettings.labelsToAxisSpacingX = 15
        chartSettings.labelsToAxisSpacingY = 15
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        
        let labelWidth: CGFloat = 70
        let labelHeight: CGFloat = 30
        
        let showCoordsTextViewsGenerator = {(chartPointModel: ChartPointLayerModel, layer: ChartPointsLayer, chart: Chart) -> UIView? in
            let (chartPoint, screenLoc) = (chartPointModel.chartPoint, chartPointModel.screenLoc)
            let text = CurrencyFormattedNumber(for: chartPoint.y.scalar, in: currency).formattedNumber
            let font = ExamplesDefaults.labelFont
            let x = min(screenLoc.x + 5, chart.bounds.width - text.width(font) - 5)
            let view = UIView(frame: CGRect(x: x, y: screenLoc.y - labelHeight, width: labelWidth, height: labelHeight))
            let label = UILabel(frame: view.bounds)
            label.text = text
            label.font = ExamplesDefaults.labelFont
            view.addSubview(label)
            view.alpha = 0
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                view.alpha = 1
            }, completion: nil)
            
            return view
        }
        
        let showCoordsLinesLayer = ChartShowCoordsLinesLayer<ChartPoint>(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, chartPoints: chartPoints)
        
        let showCoordsTextLayer = ChartPointsSingleViewLayer<ChartPoint, UIView>(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, innerFrame: innerFrame, chartPoints: chartPoints, viewGenerator: showCoordsTextViewsGenerator, mode: .custom, keepOnFront: true)
        // To preserve the offset of the notification views from the chart point they represent, during transforms, we need to pass mode: .custom along with this custom transformer.
        showCoordsTextLayer.customTransformer = {(model, view, layer) -> Void in
            guard let chart = layer.chart else {return}
            
            let text = model.chartPoint.description
            
            let screenLoc = layer.modelLocToScreenLoc(x: model.chartPoint.x.scalar, y: model.chartPoint.y.scalar)
            let x = min(screenLoc.x + 5, chart.bounds.width - text.width(ExamplesDefaults.labelFont) - 5)
            
            view.frame.origin = CGPoint(x: x, y: screenLoc.y - labelHeight)
        }
        
        let touchViewsGenerator = {(chartPointModel: ChartPointLayerModel, layer: ChartPointsLayer, chart: Chart) -> UIView? in
            let (chartPoint, screenLoc) = (chartPointModel.chartPoint, chartPointModel.screenLoc)
            let s: CGFloat = 30
            let view = HandlingView(frame: CGRect(x: screenLoc.x - s/2, y: screenLoc.y - s/2, width: s, height: s))
            view.touchHandler = {[showCoordsLinesLayer, showCoordsTextLayer, chartPoint, chart] in
                showCoordsLinesLayer.showChartPointLines(chartPoint, chart: chart)
                showCoordsTextLayer.showView(chartPoint: chartPoint, chart: chart)
            }
            return view
        }
        
        let touchLayer = ChartPointsViewsLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, chartPoints: chartPoints, viewGenerator: touchViewsGenerator, mode: .translate, keepOnFront: true)
        
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.init(white: 0, alpha: 0.2), lineWidth: 3, animDuration: 0.7, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel])
        
        let circleViewGenerator = {(chartPointModel: ChartPointLayerModel, layer: ChartPointsLayer, chart: Chart) -> UIView? in
            let circleView = ChartPointEllipseView(center: chartPointModel.screenLoc, diameter: 12)
            circleView.animDuration = 1.5
            circleView.fillColor = UIColor.white
            circleView.borderWidth = 3
            circleView.borderColor = UIColor.black
            return circleView
        }
        let chartPointsCircleLayer = ChartPointsViewsLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, chartPoints: chartPoints, viewGenerator: circleViewGenerator, displayDelay: 0, delayBetweenItems: 0.05, mode: .translate)
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
        
        
        self.chart = Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                guidelinesLayer,
                showCoordsLinesLayer,
                chartPointsLineLayer,
                chartPointsCircleLayer,
                showCoordsTextLayer,
                touchLayer,
                
                ]
        )
        
        self.containerView.addSubview(chart!.view)
    }

    func chartFrame(_ containerBounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 70, width: containerBounds.size.width, height: containerBounds.size.height - 70)
    }
}

extension String {
    
    func size(_ font: UIFont) -> CGSize {
        return NSAttributedString(string: self, attributes: [.font: font]).size()
    }
    
    func width(_ font: UIFont) -> CGFloat {
        return size(font).width
    }
    
    func height(_ font: UIFont) -> CGFloat {
        return size(font).height
    }
}

struct ExamplesDefaults {
    
    static var chartSettings: ChartSettings {
        return iPhoneChartSettings
    }
    
    static var chartSettingsWithPanZoom: ChartSettings {
        return iPhoneChartSettingsWithPanZoom
    }
    
    fileprivate static var iPhoneChartSettings: ChartSettings {
        var chartSettings = ChartSettings()
        chartSettings.leading = 10
        chartSettings.top = 10
        chartSettings.trailing = 10
        chartSettings.bottom = 10
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8
        chartSettings.labelsSpacing = 0
        return chartSettings
    }
    
    fileprivate static var iPhoneChartSettingsWithPanZoom: ChartSettings {
        var chartSettings = iPhoneChartSettings
        chartSettings.zoomPan.panEnabled = true
        chartSettings.zoomPan.zoomEnabled = true
        return chartSettings
    }
    
    static func chartFrame(_ containerBounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: containerBounds.size.width, height: containerBounds.size.height - 0)
    }
    
    static var labelSettings: ChartLabelSettings {
        return ChartLabelSettings(font: ExamplesDefaults.labelFont)
    }
    
    static var labelFont: UIFont {
        return ExamplesDefaults.fontWithSize(11)
    }
    
    static var labelFontSmall: UIFont {
        return ExamplesDefaults.fontWithSize(10)
    }
    
    static func fontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static var guidelinesWidth: CGFloat {
        return 0.1
    }
    
    static var minBarSpacing: CGFloat {
        return 5
    }
}

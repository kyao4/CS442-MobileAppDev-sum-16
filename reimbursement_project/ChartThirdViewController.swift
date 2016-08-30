//
//  ChartThirdViewController.swift
//  reimbursement_project
//
//  Created by Eddie Yao on 16/6/23.
//  Copyright © 2016年 Kai Yao. All rights reserved.
//

import Foundation
import UIKit
import Charts
import CoreData

class ChartThirdViewController: UIViewController {
    
    var category: String?
    var chartType: String?
    var xData: [String] = Array()
    var yData: [Double] = Array()
    var year: Int?
    
    @IBOutlet weak var chartView: BarChartView!
    
    
    override func viewDidLoad() {
        print("\(category) and \(chartType) and \(year)")
        if category == "By Department" {
            (xData, yData) = ChartModel.getAmountSumWithDepartment()
        } else {
            (xData, yData) = ChartModel.getAmountSumWithPaymentDate(year!)
        }
        print(xData)
        print(yData)
        
        setupPieChart()
    }

    
    func setupPieChart() {
        var pieChartView: PieChartView? = nil
        var barChartView: BarChartView? = nil
        var lineChartView: LineChartView? = nil
        switch chartType! {
        case "Pie Chart":
            pieChartView = PieChartView(frame: CGRectIntersection(chartView.frame, chartView.superview!.bounds))
            
            
            var dataEntries: [ChartDataEntry] = []
            
            for i in 0..<xData.count {
                let dataEntry = BarChartDataEntry(value: yData[i], xIndex: i)
                dataEntries.append(dataEntry)
            }
            //purge y
            for i in 0..<yData.count {
                if yData[i] < 200000 {
                    xData[i] = ""
                }
            }
            
            let chartDataSet = PieChartDataSet(yVals: dataEntries, label: category!)
            let chartData = PieChartData(xVals: xData, dataSet: chartDataSet)
            chartData.setDrawValues(false)
            pieChartView!.data = chartData
            
            var colors: [UIColor] = []
            
            for _ in 0..<xData.count {
                let red = Double(arc4random_uniform(256))
                let green = Double(arc4random_uniform(256))
                let blue = Double(arc4random_uniform(256))
                
                let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
                colors.append(color)
            }
            
            chartDataSet.colors = colors
            
            
   
            
        case "Bar Chart":
            barChartView = BarChartView(frame: CGRectIntersection(chartView.frame, chartView.superview!.bounds))
            
            var dataEntries: [BarChartDataEntry] = []
            
            for i in 0..<xData.count {
                let dataEntry = BarChartDataEntry(value: yData[i], xIndex: i)
                dataEntries.append(dataEntry)
            }
            
            let chartDataSet = BarChartDataSet(yVals: dataEntries, label: category!)
            let chartData = BarChartData(xVals: xData, dataSet: chartDataSet)
            barChartView!.data = chartData
            
        case "Line Chart year: 2016", "Line Chart year: 2015":
            lineChartView = LineChartView(frame: CGRectIntersection(chartView.frame, chartView.superview!.bounds))
            var dataEntries: [ChartDataEntry] = []
            
            for i in 0..<xData.count {
                let dataEntry = ChartDataEntry(value: yData[i], xIndex: i)
                dataEntries.append(dataEntry)
            }
            
            let chartDataSet = LineChartDataSet(yVals: dataEntries, label: category!)
            let chartData = LineChartData(xVals: xData, dataSet: chartDataSet)
            lineChartView!.data = chartData
            print("year: \(year!)")

            
            
        default:
            print("ChartType error!")
        }
        
        
        let view = pieChartView ?? barChartView ?? lineChartView
        view!.noDataText = "why there is no chart??"
        self.view.addSubview(view!)

        view!.animate(xAxisDuration: 3.0, yAxisDuration: 3.0)
        
    }
    
    
    
}



class xFormatter: ChartXAxisValueFormatter {
    @objc func stringForXValue(index: Int, original: String, viewPortHandler: ChartViewPortHandler) -> String {
        if Double(original) < 200000 {
            return ""
        } else {
            return original
        }
    }
}

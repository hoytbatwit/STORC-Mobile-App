//
//  DetailedBreakdownViewController.swift
//  STORC-Mobile-App
//
//  Created by Gabriel Baffo on 7/18/23.
//

import UIKit
import Charts

class DetailedBreakdownViewController: UIViewController {
    
    @IBOutlet weak var recentContractionHRChart: LineChartView!
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupRecentContractionHRChart()
    }
    
    func setupRecentContractionHRChart(){
        var dataPoints:[Double:Double] = [0.00:79, 0.05:85, 0.10:83, 0.15:82, 0.20:82, 0.25:74, 0.30:78, 0.35:80, 0.40:79, 0.45:79, 0.50:78, 0.55:78, 1.00:82, 1.05:82, 1.10:82, 1.15:80, 1.20:78, 1.25:82, 1.30:83]
        
        let dataSet = LineChartDataSet()
        for dataPoint in dataPoints {
            dataSet.addEntryOrdered(ChartDataEntry(x: dataPoint.key, y: dataPoint.value))
        }
        dataSet.label = "BPM"
        dataSet.valueLabelAngle = 45
        dataSet.drawFilledEnabled = true
        dataSet.mode = .horizontalBezier
        dataSet.circleRadius = 1
        dataSet.colors = [UIColor(red: 242/255, green: 165/255, blue: 163/255, alpha: 1.0)]
        dataSet.circleColors = [UIColor(red: 242/255, green: 165/255, blue: 163/255, alpha: 1.0)]
        
        let data = LineChartData(dataSet: dataSet)
        data.setDrawValues(true)
        //data.colors = UIColor.systemPink
        
        let colorTop = UIColor(red: 242/255, green: 165/255, blue: 163/255, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        let gradientColors = [colorTop, colorBottom] as CFArray
        let colorLocations:[CGFloat] = [0.0, 1.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        dataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90.0)

        
        recentContractionHRChart.xAxis.drawLabelsEnabled = true
        recentContractionHRChart.xAxis.labelPosition = .bottom
        recentContractionHRChart.xAxis.drawGridLinesEnabled = true
        recentContractionHRChart.chartDescription.enabled = true
        recentContractionHRChart.legend.enabled = true
        recentContractionHRChart.rightAxis.enabled = true
        recentContractionHRChart.leftAxis.drawGridLinesEnabled = false
        recentContractionHRChart.leftAxis.drawLabelsEnabled = true
        recentContractionHRChart.leftAxis.axisLineWidth = 0
        recentContractionHRChart.xAxis.axisLineWidth = 0
        
        recentContractionHRChart.autoScaleMinMaxEnabled = false
        recentContractionHRChart.data = data
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  DetailedBreakdownViewController.swift
//  STORC-Mobile-App
//
//  Created by Gabriel Baffo on 7/18/23.
//

import UIKit
import Charts
import CoreData

class DetailedBreakdownViewController: UIViewController {
    
    var contractionDate = Date()
    var contractionHRValues = [Int]()
    var contractionHRDataPoints = [Double : Int]()
    var context:NSManagedObjectContext!
    
    @IBOutlet weak var contractionBPMLabel: UILabel!
    @IBOutlet weak var contractionDateLabel: UILabel!
    @IBOutlet weak var recentContractionHRChart: LineChartView!
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func deleteButtonPressed(_ sender: Any) {
        deleteContraction(contractionDate: contractionDate)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        setupRecentContractionHRChart(dataPoints: contractionHRDataPoints)
        contractionDateLabel.text = "\(contractionDate)"
        contractionBPMLabel.text = "\(contractionHRValues.max() ?? -1) / \(contractionHRValues.min() ?? -1) BPM"
    }
    
    /**
     * Sets up the chart displaying information regarding the most recently detected contraction.
     *
     * @param dataPoints The data points to display on the graph.
     */
    func setupRecentContractionHRChart(dataPoints: [Double: Int]){
        let dataSet = LineChartDataSet()
        for dataPoint in dataPoints {
            dataSet.addEntryOrdered(ChartDataEntry(x: dataPoint.key, y: Double(dataPoint.value)))
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
    
    /**
     * Returns  a list of all previously detected contractions from CoreData.
     */
    func deleteContraction(contractionDate : Date) {
        var contractionDataPoints = [Date : [Double: Int]]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contraction")
        request.returnsObjectsAsFaults = false
        let result = try? context.fetch(request)

        for data in result as! [NSManagedObject] {
            if(data.value(forKey: "timeOccurred") as! Date == contractionDate){
                context.delete(data)
            }
        }
        do {
            try context.save()
            print("Successfully deleted object")
        } catch {
            print("Fetching data Failed")
        }
        self.dismiss(animated: true)
    }
    
}

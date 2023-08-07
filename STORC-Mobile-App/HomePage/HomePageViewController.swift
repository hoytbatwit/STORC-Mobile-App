//
//  HomePageViewController.swift
//  STORC-Mobile-App
//
//  Created by Gabriel Baffo on 6/19/23.
//

import UIKit
import Charts
import CoreData
import WatchConnectivity
import HealthKit

class HomePageViewController: UIViewController, WCSessionDelegate {
    var HRData = LinkedList<HeartRateDataPoint>()

    @IBOutlet weak var recentContractionHRChart: LineChartView!
    @IBOutlet weak var lastRecordedContractionView: UIView!
    @IBOutlet weak var historicalRecordsView: UIView!
    @IBOutlet weak var historicalRecordsCountLabel: UILabel!
    @IBOutlet weak var dateOfMostRecentContractionLabel: UILabel!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var detectedHRLabel: UILabel!
    
    @IBAction func detailedBreakdownButtonPressed(_ sender: Any) {
        if(!contractionValues.isEmpty){
            self.performSegue(withIdentifier: "viewDetailedBreakdownPressed", sender: self)
        }
    }
    
    var contractionMonitoringDriver = ContractionMonitoringDriver()
    var context:NSManagedObjectContext!
    var contractionValues = [Date : [Double: Int]]()
    var mostRecentContractionDate = Date()
    var mostRecentContraction = [Double:Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup view and initial operations.
        if(WCSession.isSupported()){
            let session = WCSession.default
            session.delegate = self
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        setupLastRecordedContractionView()
        setupHistoricalRecordsView()
        
        self.fillViewsWithMostRecentContractionData()
                
        let contractionConfirmedNotificationName = NSNotification.Name(rawValue:"ContractionConfirmedNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(self.fillViewsWithMostRecentContractionData), name: contractionConfirmedNotificationName, object: nil)
        
        self.pushValidContraction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fillViewsWithMostRecentContractionData()
    }
    
    // Required delegate functions for WCSession
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if(message.isEmpty || message["HRData"] == nil){
            return
        }
        let incomingDatapoint = message["HRData"]
        let HR = incomingDatapoint as! Int

        DispatchQueue.main.async {
            self.detectedHRLabel.text = "\(HR)"
        }
    }
    
    
    /**
     * Cretes and pushes  a valid contraction to the ContractionMonitoringDriver for processing.
     */
    func pushValidContraction(){
        let potentialContractionHeartRateDataPointList = [        HeartRateDataPoint(heartRateValue: 78, timeStamp: 0),
            HeartRateDataPoint(heartRateValue: 78, timeStamp: 0.05),
            HeartRateDataPoint(heartRateValue: 78, timeStamp: 0.10),
            HeartRateDataPoint(heartRateValue: 78, timeStamp: 0.15),
            HeartRateDataPoint(heartRateValue: 85, timeStamp: 0.20),
            HeartRateDataPoint(heartRateValue: 85, timeStamp: 0.25),
            HeartRateDataPoint(heartRateValue: 82, timeStamp: 0.30),
            HeartRateDataPoint(heartRateValue: 82, timeStamp: 0.35),
            HeartRateDataPoint(heartRateValue: 82, timeStamp: 0.40),
            HeartRateDataPoint(heartRateValue: 80, timeStamp: 0.45),
            HeartRateDataPoint(heartRateValue: 84, timeStamp: 0.50),
            HeartRateDataPoint(heartRateValue: 84, timeStamp: 0.55),
            HeartRateDataPoint(heartRateValue: 80, timeStamp: 1.0),
            HeartRateDataPoint(heartRateValue: 76, timeStamp: 1.05),
            HeartRateDataPoint(heartRateValue: 78, timeStamp: 1.10),
            HeartRateDataPoint(heartRateValue: 78, timeStamp: 1.15),
            HeartRateDataPoint(heartRateValue: 78, timeStamp: 1.20),
            HeartRateDataPoint(heartRateValue: 81, timeStamp: 1.25),
            HeartRateDataPoint(heartRateValue: 82, timeStamp: 1.30)]
        
        var potentialContractionHeartRateDataPointLinkedList = LinkedList<HeartRateDataPoint>()
        for heartRateDataPoint in potentialContractionHeartRateDataPointList {
            if(potentialContractionHeartRateDataPointLinkedList.isEmpty){
                potentialContractionHeartRateDataPointLinkedList.push(heartRateDataPoint)
                continue
            }
            potentialContractionHeartRateDataPointLinkedList.append(heartRateDataPoint)
        }
        
        // Sends a notification to the ContractionMonitoringDriver with the potentialContractionHeartRateDataPointList regarding a potential contraction.
        let notificationName = Notification.Name(rawValue: "NewHeartRateValueReceived")
        NotificationCenter.default.post(name: notificationName, object: potentialContractionHeartRateDataPointLinkedList)

    }
    
    // UI Setup for historical records view.
    func setupHistoricalRecordsView(){
        historicalRecordsView.layer.cornerRadius = 10
    }
    
    // UI Setup for last recorded contraction view.
    func setupLastRecordedContractionView(){
        lastRecordedContractionView.layer.cornerRadius = 10
        lastRecordedContractionView.layer.borderWidth = 1
        lastRecordedContractionView.layer.borderColor = UIColor(red: 242/255, green: 165/255, blue: 163/255, alpha: 1.0).cgColor
    }
    
    // Fill the corresponding views with the data corresponding to the most recently detected contraction.
    @objc func fillViewsWithMostRecentContractionData(){
        contractionValues = getContractions()
        mostRecentContraction = contractionValues[contractionValues.keys.max() ?? Date.now] ?? [:]
        
        if(!contractionValues.isEmpty){
            setupRecentContractionHRChart(dataPoints: mostRecentContraction)
        }else{
            setupRecentContractionHRChart(dataPoints: [:])
            dateOfMostRecentContractionLabel.text = "No Contractions Detected"
        }
        
        let maxBPM = mostRecentContraction.values.max()
        let minBPM = mostRecentContraction.values.min()
        bpmLabel.text = "\(maxBPM ?? 0) / \(minBPM ?? 0) BPM"

        historicalRecordsCountLabel.text = "\(contractionValues.count)"
        
        if(!contractionValues.isEmpty){
            dateOfMostRecentContractionLabel.text = "\(contractionValues.keys.max()!)"
            mostRecentContractionDate = contractionValues.keys.max()!
        }
    }
    
    /**
     * Sets up the chart displaying information regarding the most recently detected contraction.
     *
     * @param dataPoints The data points to display on the graph.
     */
    func setupRecentContractionHRChart(dataPoints: [Double: Int]){
        let dataSet = LineChartDataSet()
        dataSet.label = "BPM"
        dataSet.drawFilledEnabled = true
        dataSet.mode = .horizontalBezier
        dataSet.circleRadius = 1
        dataSet.colors = [UIColor(red: 242/255, green: 165/255, blue: 163/255, alpha: 1.0)]
        dataSet.circleColors = [UIColor(red: 242/255, green: 165/255, blue: 163/255, alpha: 1.0)]
        
        for dataPoint in dataPoints {
            dataSet.addEntryOrdered(ChartDataEntry(x: dataPoint.key, y: Double(dataPoint.value)))
        }
        
        let data = LineChartData(dataSet: dataSet)
        data.setDrawValues(false)
        
        let colorTop = UIColor(red: 242/255, green: 165/255, blue: 163/255, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        let gradientColors = [colorTop, colorBottom] as CFArray
        let colorLocations:[CGFloat] = [0.0, 1.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        
        dataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90.0)
        
        recentContractionHRChart.xAxis.drawLabelsEnabled = false
        recentContractionHRChart.xAxis.labelPosition = .bottom
        recentContractionHRChart.xAxis.drawGridLinesEnabled = false
        recentContractionHRChart.chartDescription.enabled = false
        recentContractionHRChart.legend.enabled = false
        recentContractionHRChart.rightAxis.enabled = false
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
    func getContractions() -> [Date : [Double: Int]]{
        var contractionDataPoints = [Date : [Double: Int]]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contraction")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let heartRateValuesString = data.value(forKey: "heartRateValues") as! String
                let setStringAsData = heartRateValuesString.data(using: String.Encoding.utf16)
                let setBack: [Int] = try! JSONDecoder().decode([Int].self, from: setStringAsData!)
                var setBackWithTimeIncrements = [Double : Int]()
                var timeCount : Double = 0
                
                for hrValue in setBack {
                    setBackWithTimeIncrements.updateValue(hrValue, forKey: timeCount)
                    if(timeCount == 0.55){
                        timeCount = 1.00
                    }else{
                        timeCount += 0.05
                    }
                    timeCount = Double(String(format: "%.2f", timeCount))!
                }
                let timeOccurred = data.value(forKey: "timeOccurred") as! Date
                contractionDataPoints.updateValue(setBackWithTimeIncrements, forKey: timeOccurred)
            }
            
            print(contractionDataPoints)
            return contractionDataPoints
        } catch {
            print("Fetching data Failed")
            return [:]
        }
    }
    
    
    func getRestingHR(completion: @escaping (Bool, Double) -> ()){
        var healthStore : HKHealthStore?
        
        if HKHealthStore.isHealthDataAvailable(){
            healthStore = HKHealthStore()
        }else{
            //no health data available
            print("error health data unavailable")
        }
        
        let dataType = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        healthStore?.requestAuthorization(toShare: dataType, read: dataType) { success, error in
            if success{
                print("Health auth successfull")
            }else{
                //error
                print("unable to get read or write access")
            }
        }
        
        let heartRateUnit:HKUnit = HKUnit(from: "count/min")
        var HR: Double = 0.0
        let query = HKSampleQuery(sampleType: HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.restingHeartRate)!, predicate: nil, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil)  { query, results, error in
            
            guard let samples = results as? [HKQuantitySample] else{
                print("Error: ", error)
                completion(true, 53)
                return
            }
            
            for sample in samples {
                HR = sample.quantity.doubleValue(for: heartRateUnit)
            }
                
            print(HR, " RESTING HR")
            // Sends the heart rate data to the iPhone device.
            completion(true, HR)
        }
        healthStore?.execute(query)
    }
    
    // Prepares for segue between the dashboard and the view contraction details page.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "viewDetailedBreakdownPressed"){
            let vc =  segue.destination as! DetailedBreakdownViewController
            vc.contractionDate = mostRecentContractionDate
            vc.contractionHRDataPoints = mostRecentContraction
            vc.contractionHRValues = mostRecentContraction.values.map({ hrValue in
                return hrValue
            })
        }
    }

}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

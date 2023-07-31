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

class HomePageViewController: UIViewController, WCSessionDelegate {
    var HRData = LinkedList<HeartRateDataPoint>()

    @IBOutlet weak var recentContractionHRChart: LineChartView!
    @IBOutlet weak var lastRecordedContractionView: UIView!
    
    @IBOutlet weak var historicalRecordsView: UIView!
    
    @IBOutlet weak var historicalRecordsCountLabel: UILabel!
    
    @IBOutlet weak var dateOfMostRecentContractionLabel: UILabel!
    
    @IBOutlet weak var bpmLabel: UILabel!
    
    @IBAction func detailedBreakdownButtonPressed(_ sender: Any) {
        if(!contractionValues.isEmpty){
            self.performSegue(withIdentifier: "viewDetailedBreakdownPressed", sender: self)
        }
    }
    let contractionMonitoringDriver = ContractionMonitoringDriver()
    
    var context:NSManagedObjectContext!
    
    var contractionValues = [Date : [Double: Int]]()
    var mostRecentContractionDate = Date()
    var mostRecentContraction = [Double:Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        contractionValues = getContractions()
        
        mostRecentContraction = contractionValues[contractionValues.keys.max() ?? Date.now] ?? [:]
        
        // Do any additional setup after loading the view.
        if(!contractionValues.isEmpty){
            setupRecentContractionHRChart(dataPoints: mostRecentContraction)
        }
        
        setupLastRecordedContractionView()
        setupHistoricalRecordsView()
        
        let maxBPM = mostRecentContraction.values.max()
        let minBPM = mostRecentContraction.values.min()
        
        bpmLabel.text = "\(maxBPM ?? 0) / \(minBPM ?? 0) BPM"
        
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
//            heartRateDataPointNode!.next = Node(value: heartRateDataPoint)
//            heartRateDataPointNode = (heartRateDataPointNode?.next)!
            if(potentialContractionHeartRateDataPointLinkedList.isEmpty){
                potentialContractionHeartRateDataPointLinkedList.push(heartRateDataPoint)
                continue
            }
            potentialContractionHeartRateDataPointLinkedList.append(heartRateDataPoint)
        }
        
        print(potentialContractionHeartRateDataPointLinkedList)
        
        let notificationName = Notification.Name(rawValue: "NewHeartRateValueReceived")
        NotificationCenter.default.post(name: notificationName, object: potentialContractionHeartRateDataPointLinkedList)
        
        historicalRecordsCountLabel.text = "\(contractionValues.count)"
        if(!contractionValues.isEmpty){
            dateOfMostRecentContractionLabel.text = "\(contractionValues.keys.max()!)"
            mostRecentContractionDate = contractionValues.keys.max()!
        }
//
//        if(WCSession.isSupported()){
//            let session = WCSession.default
//            session.delegate = self
//            session.activate()
//        }
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {
        //session.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        let incomingDatapoint = message["message"] as? [Any]
        print(incomingDatapoint, " THIS IS MESSAGE")
        //let incomingDatapoint = message["message"] as? HeartRateDatapoint
        //let HR = incomingDatapoint?.getHeartRateValue()
        //let HRDate = incomingDatapoint?.getTimeStampValue()
        let HR = incomingDatapoint?[0]
        let HRDate = incomingDatapoint?[1]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        //print("\(HRTime!)")
        
        //need to differentiate between 1st and not 1st because if not some stuff wont work
        //also preserves the order that stuff was sent in
//        if(HRData.isEmpty == true){
//            HRData.push(HeartRateDataPoint(heartRateValue: HR! as! Int, timeStamp: HRDate! as! Date))
//        }else{
//            HRData.append(HeartRateDataPoint(heartRateValue: HR! as! Int, timeStamp: HRDate! as! Date))
//        }
        DispatchQueue.main.async {
            self.bpmLabel.text = String(HR! as! Int)
        }
    }
    

    func setupHistoricalRecordsView(){
        historicalRecordsView.layer.cornerRadius = 10
    }
    
    func setupLastRecordedContractionView(){
        lastRecordedContractionView.layer.cornerRadius = 10
        lastRecordedContractionView.layer.borderWidth = 1
        lastRecordedContractionView.layer.borderColor = UIColor(red: 242/255, green: 165/255, blue: 163/255, alpha: 1.0).cgColor
    }
    
    
    func setupRecentContractionHRChart(dataPoints: [Double: Int]){
        
        let dataSet = LineChartDataSet()
        for dataPoint in dataPoints {
            dataSet.addEntryOrdered(ChartDataEntry(x: dataPoint.key, y: Double(dataPoint.value)))
        }
        dataSet.label = "BPM"
        dataSet.drawFilledEnabled = true
        dataSet.mode = .horizontalBezier
        dataSet.circleRadius = 1
        dataSet.colors = [UIColor(red: 242/255, green: 165/255, blue: 163/255, alpha: 1.0)]
        dataSet.circleColors = [UIColor(red: 242/255, green: 165/255, blue: 163/255, alpha: 1.0)]
        
        let data = LineChartData(dataSet: dataSet)
        data.setDrawValues(false)
        //data.colors = UIColor.systemPink
        
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
    
    func getContractions() -> [Date : [Double: Int]]{
        var contractionDataPoints = [Date : [Double: Int]]()
        
        print("Fetching Data..")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

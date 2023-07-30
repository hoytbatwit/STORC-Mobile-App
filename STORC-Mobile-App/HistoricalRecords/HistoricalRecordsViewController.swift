//
//  HistoricalRecordsViewController.swift
//  STORC-Mobile-App
//
//

import UIKit
import CoreData

class HistoricalRecordsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var context:NSManagedObjectContext!

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contractionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricalRecordCell", for: indexPath) as! HistoricalRecordTableViewCell
        cell.bgView.layer.cornerRadius = 10
        
        let maxValue = contractionsList[indexPath.row].first?.value.values.max()
        let minValue = contractionsList[indexPath.row].first?.value.values.min()
                
        cell.bpmLabel.text = "\(maxValue ?? -1) / \(minValue ?? -1) BPM"
        
        cell.dateTimeLabel.text = "\(contractionsList[indexPath.row].first?.key ?? Date.distantFuture)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedContractionDate = contractionsList[indexPath.row].first?.key ?? Date.distantFuture
        selectedHRDataPoints = contractionsList[indexPath.row].first?.value ?? [:]
        selectedContractionHRValues = (contractionsList[indexPath.row].first?.value.values.map({ hrValue in
            return hrValue
        })) ?? []
        self.performSegue(withIdentifier: "historicalRecordsToDetailedBreakdown", sender: self)
    }
    
    var selectedContractionDate = Date()
    var selectedContractionHRValues = [Int]()
    var selectedHRDataPoints = [Double : Int]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "historicalRecordsToDetailedBreakdown"){
            let vc = segue.destination as! DetailedBreakdownViewController
            
            vc.contractionDate = selectedContractionDate
            vc.contractionHRDataPoints = selectedHRDataPoints
            vc.contractionHRValues = selectedContractionHRValues
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var historicalRecordsTableView: UITableView!
    
    var contractionsList = [[Date : [Double: Int]]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        var unmodifiedContractionsList = getContractions()

        for contractionKey in unmodifiedContractionsList.keys {
            contractionsList.append([contractionKey : unmodifiedContractionsList[contractionKey]!])
        }
        
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

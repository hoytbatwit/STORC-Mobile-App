//
//  ContentView.swift
//  WatchApp WatchKit Extension
//
//  Created by Brian H on 8/3/23.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    var model = WatchConectControll()
    @State var messageText = ""
    
    // Set up swift UI view.
    var body: some View {
        VStack{
            Label("", systemImage: "heart.fill")
            Button(action: {
                getAuth()
            }){
                Text("Send Message")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accentColor(Color.black)
        .background(Color.pink)
    }


    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    
    /**
     * This function obtains authorization from the HealthStore to query for heart rate data and queries for the most recently stored heart rate value(s).
     */
    func getAuth(){
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
        let query = HKSampleQuery(sampleType: HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!, predicate: nil, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil)  { query, results, error in
            
            guard let samples = results as? [HKQuantitySample] else{
                print("Error")
                return
            }
            
            for sample in samples {
                HR = sample.quantity.doubleValue(for: heartRateUnit)
            }
                
            // Sends the heart rate data to the iPhone device.
            DispatchQueue.main.async{
                self.model.session.sendMessage(["HRData": HR], replyHandler: nil) { (error) in print("There was an error sending the message")}
            }
        }
        healthStore?.execute(query)
    }
}
    

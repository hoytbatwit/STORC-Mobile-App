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
    
    
    var body: some View {
        VStack{
            Label("", systemImage: "heart.fill")
            Button(action: {
                getAuth()
//                self.model.session.sendMessage(["message": self.messageText], replyHandler: nil) { (error) in print(error.localizedDescription)}
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
        
        print(HR)
        
        DispatchQueue.main.async{
            //add in code here to display text to user so it can be seen and can be sent
            print("Do we enter here or no")
            self.model.session.sendMessage(["HRData": HR], replyHandler: nil) { (error) in print("There was an error sending the message")}
        }
    }
    healthStore?.execute(query)
}

}
    

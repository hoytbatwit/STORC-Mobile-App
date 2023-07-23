//
//  HeartRateDatapoint.swift
//  STORC-Mobile-App
//
//  Created by Brian H on 7/21/23.
//

import Foundation

class HeartRateDatapoint {
    private var heartRateValue: Double
    private let timeStamp: Date
    
    init(heartRateValue: Double, timeStamp: Date){
        self.heartRateValue = heartRateValue
        self.timeStamp = timeStamp
    }
    
    public func getHeartRateValue() -> Double{
        return self.heartRateValue
    }
    
    public func getTimeStampValue() -> Date{
        return self.timeStamp
    }
    
    public func setHeartRateValue(heartRateValue:Double){
        self.heartRateValue = heartRateValue
    }
}

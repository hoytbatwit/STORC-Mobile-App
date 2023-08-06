//
//  HeartRateDatapoint.swift
//  STORC-Mobile-App
//
//  Created by Gabriel Baffo on 7/6/23.
//

import Foundation

class HeartRateDataPoint {
    private var heartRateValue : Int
    private let timeStamp : Double
    
    init(heartRateValue: Int, timeStamp:Double ) {
        self.heartRateValue = heartRateValue
        self.timeStamp = timeStamp
    }
    
    public func getHeartRateValue() -> Int{
        return self.heartRateValue
    }
    
    public func getTimeStampValue() -> Double{
        return self.timeStamp
    }
    
    public func setHeartRateValue(heartRateValue:Int){
        self.heartRateValue = heartRateValue
    }
}

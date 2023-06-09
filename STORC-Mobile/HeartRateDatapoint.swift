//
//  HeartRateDatapoint.swift
//  STORC-Mobile
//
//  Created by Brian H on 6/9/23.
//

import Foundation

class HeartRateDatapoint {
    private Int heartRateValue;
    
    private final double timeStamp;
    
    HeartRateDatapoint(Int heartRateValue, double timeStamp){
        this.heartRateValue = heartRateValue;
        this.timeStamp = timeStamp;
    }
    
    public Int getHeartRateValues(){
        return this.heartRateValue;
    }
    
    public double getTimeStampValue(){
        return this.timeStamp();
    }
    
    public void setHeartRateValue(Int heartRateValue){
        this.heartRateValue = heartRateValue;
    }
}

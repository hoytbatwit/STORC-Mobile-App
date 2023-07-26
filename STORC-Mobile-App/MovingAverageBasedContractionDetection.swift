//
//  ContractionMonitor.swift
//  STORC-Mobile-App
//
//  Created by Gabriel Baffo on 7/6/23.
//

import Foundation

class MovingAverageBasedContractionDetection {
    public func monitor(heartRateValues: [HeartRateDataPoint], average: Int){
        var currentContractionValues = [HeartRateDataPoint]()
        
        var isContractionOccuring = false;
        
        var contractionStartDataPoint = HeartRateDataPoint(heartRateValue: 0, timeStamp: 0.0)
        var contractionPeakHR = HeartRateDataPoint(heartRateValue: Int.min, timeStamp: 0.0)
        
        for currentHeartRateDataPoint in heartRateValues {
            
            if(contractionPeakHR.getHeartRateValue() < currentHeartRateDataPoint.getHeartRateValue()){
                contractionPeakHR = currentHeartRateDataPoint
            }
            
            if(isContractionOccuring){
                if(checkIfEndOfContraction(peak: contractionPeakHR.getHeartRateValue(), current: currentHeartRateDataPoint.getHeartRateValue())){
                    isContractionOccuring = false
                    
                    print("")
                    print("Contraction Start HR: ", contractionStartDataPoint.getHeartRateValue())
                    print("Contraction Start Time: ", contractionStartDataPoint.getTimeStampValue())
                    print("Peak HR during Contraction: ", determinePeakDuringContraction(heartRateDataPoints: currentContractionValues))
                    print("HR at End of Contraction: ", currentHeartRateDataPoint.getHeartRateValue())
                    print("Time at End of Contraction: ", currentHeartRateDataPoint.getTimeStampValue())
                    print("")
                    
                    
                    let notificationName = Notification.Name(rawValue: "ContractionOccurredNotification")
                    NotificationCenter.default.post(name: notificationName, object: heartRateValues)
                    
                    currentContractionValues.removeAll()
                    return
                }
            }else {
                if(checkIfStartOfContraction(current: currentHeartRateDataPoint.getHeartRateValue(), resting: average)) {
                    isContractionOccuring = true
                    contractionStartDataPoint = currentHeartRateDataPoint
                    currentContractionValues.append(currentHeartRateDataPoint)
                }

            }
        }
        if(isContractionOccuring) {
            print("No end to the contraction was detected therefore this contraction either did not happen or the data set ended.")
        }
        
    }
    
    /**
     * This will check for an increase in the users heart rate.
     * If the heart rate is raised enough we will decide a contraction is happening and
     * return true
     *
     * @param current The heart rate that the minimum is being checked against
     * @param min The smaller heart rate we are using as the benchmark to check the increase
     *
     * @returns A true value when a contraction is detected
     */
    private func checkIncrease(current:Int, min:Int) -> Bool{
        let percent = 100 * (Double(current - min) / Double(min));
        
        //If the jump is between 15 and 6 percent we belive a contraction has started.
        if(percent <= 15.00 && percent >= 6.00){
            print("A heart rate increase indicative of a contraction occurred with a jump from", min, "beats per minute to", current, "beats per minute\n");
            return true;
        }
        return false;
    }
    
    /**
     * Will check for a decrease in the users heart rate. If a decrease is detected within
     * the threshold we decide that the contraction has ended
     *
     * @param previousHigh The highest value that we check against
     * @param current The current Heart Rate
     *
     * @return A false value when we determine that the contraction has ended
     */
    private func checkDecrease(current:Int, high:Int) -> Bool{
        let percent = 100 * (Double(high - current) / Double(current));
        
        //If the jump is between 15 and 6 percent we belive a contraction has started.
        if(percent >= -15.00 && percent <= -6.00){
            print("A heart rate decrease indicative of contraction ending occurred with a decrease from", high, "beats per minute to", current, "beats per minute\n");
            return true;
        }
        return false;
    }
    
    private func determinePeakDuringContraction(heartRateDataPoints: [HeartRateDataPoint]) -> Int{
        var peak = 0
        for heartRateDataPoint in heartRateDataPoints {
            if(heartRateDataPoint.getHeartRateValue() > peak){
                peak = heartRateDataPoint.getHeartRateValue()
            }
        }
        return peak
    }
    
    
    private func checkIfStartOfContraction(current: Int, resting: Int) -> Bool{
        let percent = 100 * (Double(current - resting) / Double(abs(resting)))
        if(percent >= 6){
            return true
        }
        return false
    }

    
    private func checkIfEndOfContraction(peak: Int, current: Int) -> Bool{
        let percent = 100 * (Double(current - peak) / Double(abs(peak)))
        print("Percent ", percent, " ", current, " ", peak)
        if(percent <= -6){
            return true
        }
        return false
    }
    
    public func checkForPeakValue(current: Int, startHR: Int) -> Bool{
        let percent = 100 * (Double(startHR - current) / Double(abs(startHR)))
        if(percent >= 9){
            return true
        }
        return false
    }
    
    public func generateMovingAverage(input: [HeartRateDataPoint]) -> [HeartRateDataPoint]{
        var results = [HeartRateDataPoint]()
        // LinkedList Implementation
        var size = 5
        var sum = 0
        for currentHeartRateDataPoint in input {
            sum = sum + currentHeartRateDataPoint.getHeartRateValue()
            // Add to LinkedList
            // Check Size and remove
            
            var newValue = sum / size
            var newData = HeartRateDataPoint(heartRateValue: newValue, timeStamp: currentHeartRateDataPoint.getTimeStampValue())
            results.append(newData)
        }
        
        return results
    }
}

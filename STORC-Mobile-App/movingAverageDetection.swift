//
//  movingAverageDetection.swift
//  STORC-Mobile-App
//
//  Created by Brian H on 7/16/23.
//
import Foundation

class MovingAverageBasedContractionDetection {
    public func monitor(heartRateValue: LinkedList<HeartRateDatapoint>, average: Double){
        var currentContractionValues = LinkedList<HeartRateDatapoint>()
        
        var isContractionOccuring = false;
        var foundPeak = false;
        
        var contractionStartDataPoint = HeartRateDatapoint(heartRateValue: 0.0, timeStamp: Date.now)
        //var contractionPeakHR = HeartRateDatapoint(heartRateValue: 0.0, timeStamp: Date.now)
        var contractionPeakHR = 0.0
        
        for currentHeartRateDataPoint in heartRateValue {
            if(isContractionOccuring){
                if(checkIfEndOfContraction(peak: contractionPeakHR, current: currentHeartRateDataPoint.value.getHeartRateValue()) && foundPeak){
                    isContractionOccuring = false
                    foundPeak = false
                    
                    print("")
                    print("Contraction Start HR: ", contractionStartDataPoint.getHeartRateValue())
                    print("Contraction Start Time: ", contractionStartDataPoint.getTimeStampValue())
                    print("Peak HR during Contraction: ", determinePeakDuringContraction(heartRateDataPoints: currentContractionValues))
                    print("HR at End of Contraction: ", currentHeartRateDataPoint.value.getHeartRateValue())
                    print("Time at End of Contraction: ", currentHeartRateDataPoint.value.getTimeStampValue())
                    print("")
                
                    let notificationName = Notification.Name("ContractionOccurredNotification")
                    NotificationCenter.default.post(name: notificationName, object: currentContractionValues)
                    
                    for _ in currentContractionValues{
                        currentContractionValues.pop()
                    }
                    continue
                }else {
                    if(checkForPeakValue(current: currentHeartRateDataPoint.value.getHeartRateValue(), startHR: contractionStartDataPoint.getHeartRateValue())) {
                        foundPeak = true;
                        contractionPeakHR = currentHeartRateDataPoint.value.getHeartRateValue()
                    }
                }
            }else {
                if(checkIfStartOfContraction(current: currentHeartRateDataPoint.value.getHeartRateValue(), resting: average)) {
                    isContractionOccuring = true
                    contractionStartDataPoint = HeartRateDatapoint(heartRateValue: currentHeartRateDataPoint.value.getHeartRateValue(), timeStamp: currentHeartRateDataPoint.value.getTimeStampValue())
                    if(currentContractionValues.isEmpty == true){
                        currentContractionValues.push(HeartRateDatapoint(heartRateValue: currentHeartRateDataPoint.value.getHeartRateValue(), timeStamp: currentHeartRateDataPoint.value.getTimeStampValue()))
                    }else{
                        currentContractionValues.append(HeartRateDatapoint(heartRateValue: currentHeartRateDataPoint.value.getHeartRateValue(), timeStamp: currentHeartRateDataPoint.value.getTimeStampValue()))
                    }
                }

            }
        }
        if(foundPeak || isContractionOccuring) {
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
    private func checkIncrease(current:Double, min:Double) -> Bool{
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
    private func checkDecrease(current:Double, high:Double) -> Bool{
        let percent = 100 * (Double(high - current) / Double(current));
        
        //If the jump is between 15 and 6 percent we belive a contraction has started.
        if(percent >= -15.00 && percent <= -6.00){
            print("A heart rate decrease indicative of contraction ending occurred with a decrease from", high, "beats per minute to", current, "beats per minute\n");
            return true;
        }
        return false;
    }
    
    private func determinePeakDuringContraction(heartRateDataPoints: LinkedList<HeartRateDatapoint>) -> Double{
        var peak = 0.0
        for heartRateDataPoint in heartRateDataPoints {
            if(heartRateDataPoint.value.getHeartRateValue() > peak){
                peak = heartRateDataPoint.value.getHeartRateValue()
            }
        }
        return peak
    }
    
    
    private func checkIfStartOfContraction(current: Double, resting: Double) -> Bool{
        //let percent = 100 * (Double(current - resting) / Double(abs(resting)))
        let first = current - resting
        let percent = 100 * (first / resting)
        if(percent >= 3){
            return true
        }
        return false
    }

    
    private func checkIfEndOfContraction(peak: Double, current: Double) -> Bool{
        //let percent = 100 * (Double(current - peak) / Double(abs(peak)))
        let first = peak - current
        let percent = 100 * (first / peak)
        if(percent >= 3){
            return true
        }
        return false
    }
    
    public func checkForPeakValue(current: Double, startHR: Double) -> Bool{
        //let percent = 100 * (Double(startHR - current) / Double(abs(startHR)))
        let first = current - startHR
        let percent = 100 * (first / startHR)
        if(percent >= 3){
            return true
        }
        return false
    }
    
    public func generateMovingAverage(input: LinkedList<HeartRateDatapoint>) -> LinkedList<HeartRateDatapoint>{
        var results = LinkedList<HeartRateDatapoint>()
        // LinkedList Implementation
        var size = 5.0
        var sum = 0.0
        for currentHeartRateDataPoint in input {
            sum = sum + currentHeartRateDataPoint.value.getHeartRateValue()
            // Add to LinkedList
            // Check Size and remove
            
            var newValue = sum / size
            var newData = HeartRateDatapoint(heartRateValue: newValue, timeStamp: currentHeartRateDataPoint.value.getTimeStampValue())
            if(results.isEmpty == true){
                results.push(newData)
            }else{
                results.append(newData)
            }
            results.append(newData)
        }
        
        return results
    }
}

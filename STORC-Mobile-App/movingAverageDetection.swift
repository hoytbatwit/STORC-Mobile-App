//
//  movingAverageDetection.swift
//  STORC-Mobile-App
//
//  Created by Brian H on 7/16/23.
//
/*
import Foundation

class MovingAverageBasedContractionDetection {
    public func monitor(heartRateValue: LinkedList<Int>, average: Int){
        var currentContractionValues = LinkedList<Int>()
        
        var isContractionOccuring = false;
        var foundPeak = false;
        
        //need to figure out how to store these for new format
        //var contractionStartDataPoint = HeartRateDataPoint(heartRateValue: 0, timeStamp: 0.0)
        //var contractionPeakHR = HeartRateDataPoint(heartRateValue: Int.max, timeStamp: 0.0)
        var contractionStartHR = 0.0
        var contractionPeakHR = 0.0
        
        while heartRateValue.head?.next != nil {
            var i : Int = 0
            var currentHeartRateDataPoint = heartRateValue.getNodeAt(at: i)?.value
            
            if(isContractionOccuring){
                if(checkIfEndOfContraction(peak: contractionPeakHR, current: Double(currentHeartRateDataPoint!)) && foundPeak){
                    isContractionOccuring = false
                    foundPeak = false
                    
                    print("")
                    print("Contraction Start HR: ", contractionStartHR)
                    //will have to come back to this to figure out timing
                    //print("Contraction Start Time: ", contractionStartDataPoint.getTimeStampValue())
                    print("Peak HR during Contraction: ", determinePeakDuringContraction(heartRateDataPoints: currentContractionValues))
                    print("HR at End of Contraction: ", currentHeartRateDataPoint)
                    //again have to come back to this
                    //print("Time at End of Contraction: ", currentHeartRateDataPoint.getTimeStampValue())
                    print("")
                
                    let notificationName = Notification.Name("ContractionOccurredNotification")
                    NotificationCenter.default.post(name: notificationName, object: currentContractionValues)
                    
                    //Im going to add a remove all function to the linked list to make this easier
                    //currentContractionValues.removeAll()
                    continue
                }else {
                    if(checkForPeakValue(current: Double(currentHeartRateDataPoint!), startHR: contractionStartHR)) {
                        foundPeak = true;
                        contractionPeakHR = Double(currentHeartRateDataPoint!)
                    }
                }
            }else {
                if(checkIfStartOfContraction(current: Double(currentHeartRateDataPoint!), resting: Double(average))) {
                    isContractionOccuring = true
                    contractionStartHR = Double(currentHeartRateDataPoint!)
                    currentContractionValues.append(currentHeartRateDataPoint!)
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
    
    private func determinePeakDuringContraction(heartRateDataPoints: [HeartRateDataPoint]) -> Int{
        var peak = 0
        for heartRateDataPoint in heartRateDataPoints {
            if(heartRateDataPoint.getHeartRateValue() > peak){
                peak = heartRateDataPoint.getHeartRateValue()
            }
        }
        return peak
    }
    
    
    private func checkIfStartOfContraction(current: Double, resting: Double) -> Bool{
        let percent = 100 * (Double(current - resting) / Double(abs(resting)))
        if(percent >= 6){
            return true
        }
        return false
    }

    
    private func checkIfEndOfContraction(peak: Double, current: Double) -> Bool{
        let percent = 100 * (Double(current - peak) / Double(abs(peak)))
        if(percent >= 6){
            return true
        }
        return false
    }
    
    public func checkForPeakValue(current: Double, startHR: Double) -> Bool{
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
 */

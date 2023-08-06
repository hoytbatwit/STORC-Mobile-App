//
//  movingAverageDetection.swift
//  STORC-Mobile-App
//
//  Created by Brian H on 7/16/23.
//
import Foundation

class MovingAverageBasedContractionDetection {
    public func monitor(heartRateValue: LinkedList<HeartRateDataPoint>, average: Int){
        var currentContractionValues = LinkedList<HeartRateDataPoint>()
        
        var isContractionOccuring = false;
        //var foundPeak = false;
        
        var contractionStartDataPoint = HeartRateDataPoint(heartRateValue: 0, timeStamp: 0.0)
        //var contractionPeakHR = HeartRateDatapoint(heartRateValue: 0.0, timeStamp: Date.now)
        var contractionPeakHR = HeartRateDataPoint(heartRateValue: Int.min, timeStamp: 0.0)
        
        for currentHeartRateDataPoint in heartRateValue {
            if(contractionPeakHR.getHeartRateValue() < currentHeartRateDataPoint.value.getHeartRateValue()){
                contractionPeakHR = currentHeartRateDataPoint.value
            }
            
            if(isContractionOccuring){
                if(checkIfEndOfContraction(peak: contractionPeakHR.getHeartRateValue(), current: currentHeartRateDataPoint.value.getHeartRateValue())){
                    isContractionOccuring = false
                    
                    print("")
                    print("Contraction Start HR: ", contractionStartDataPoint.getHeartRateValue())
                    print("Contraction Start Time: ", contractionStartDataPoint.getTimeStampValue())
                    print("Peak HR during Contraction: ", determinePeakDuringContraction(heartRateDataPoints: currentContractionValues))
                    print("HR at End of Contraction: ", currentHeartRateDataPoint.value.getHeartRateValue())
                    print("Time at End of Contraction: ", currentHeartRateDataPoint.value.getTimeStampValue())
                    print("")
                
                    currentContractionValues.append(currentHeartRateDataPoint.value)

                    let notificationName = Notification.Name("ContractionOccurredNotification")
                    NotificationCenter.default.post(name: notificationName, object: currentContractionValues)
                    
                    for _ in currentContractionValues{
                        currentContractionValues.pop()
                    }
                    continue
                }else {
                    if(checkForPeakValue(current: currentHeartRateDataPoint.value.getHeartRateValue(), startHR: contractionStartDataPoint.getHeartRateValue())) {
                        contractionPeakHR = currentHeartRateDataPoint.value
                    }
                    currentContractionValues.append(currentHeartRateDataPoint.value)
                }
            }else {
                if(checkIfStartOfContraction(current: currentHeartRateDataPoint.value.getHeartRateValue(), resting: average)) {
                    isContractionOccuring = true
                    contractionStartDataPoint = HeartRateDataPoint(heartRateValue: currentHeartRateDataPoint.value.getHeartRateValue(), timeStamp: currentHeartRateDataPoint.value.getTimeStampValue())
                    if(currentContractionValues.isEmpty == true){
                        currentContractionValues.push(HeartRateDataPoint(heartRateValue: currentHeartRateDataPoint.value.getHeartRateValue(), timeStamp: currentHeartRateDataPoint.value.getTimeStampValue()))
                    }else{
                        currentContractionValues.append(HeartRateDataPoint(heartRateValue: currentHeartRateDataPoint.value.getHeartRateValue(), timeStamp: currentHeartRateDataPoint.value.getTimeStampValue()))
                    }
                }

            }
        }
        if(isContractionOccuring) {
            print("No end to the contraction was detected therefore this contraction either did not happen or the data set ended.")
        }
        
    }
    
    private func determinePeakDuringContraction(heartRateDataPoints: LinkedList<HeartRateDataPoint>) -> Int{
        var peak = 0
        for heartRateDataPoint in heartRateDataPoints {
            if(heartRateDataPoint.value.getHeartRateValue() > peak){
                peak = heartRateDataPoint.value.getHeartRateValue()
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
    
//    public func generateMovingAverage(input: LinkedList<HeartRateDataPoint>) -> LinkedList<HeartRateDataPoint>{
//        var results = LinkedList<HeartRateDataPoint>()
//        // LinkedList Implementation
//        var size = 5.0
//        var sum = 0.0
//        for currentHeartRateDataPoint in input {
//            sum = sum + Double(currentHeartRateDataPoint.value.getHeartRateValue())
//            // Add to LinkedList
//            // Check Size and remove
//            
//            var newValue = Int(sum / size)
//            var newData = HeartRateDataPoint(heartRateValue: newValue, timeStamp: currentHeartRateDataPoint.value.getTimeStampValue())
//            if(results.isEmpty == true){
//                results.push(newData)
//            }else{
//                results.append(newData)
//            }
//            results.append(newData)
//        }
//        
//        return results
//    }
}

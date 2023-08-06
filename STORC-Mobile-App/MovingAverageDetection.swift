//
//  movingAverageDetection.swift
//  STORC-Mobile-App
//
//  Created by Brian H on 7/16/23.
//
import Foundation

class MovingAverageBasedContractionDetection {
    public func monitor(heartRateValue: LinkedList<HeartRateDataPoint>, average: Int){
        // List used to store potential contraction values once a contraction has started.
        var currentContractionValues = LinkedList<HeartRateDataPoint>()
        
        var isContractionOccuring = false;
        //var foundPeak = false;
        
        var contractionStartDataPoint = HeartRateDataPoint(heartRateValue: 0, timeStamp: 0.0)
        //var contractionPeakHR = HeartRateDatapoint(heartRateValue: 0.0, timeStamp: Date.now)
        var contractionPeakHR = HeartRateDataPoint(heartRateValue: Int.min, timeStamp: 0.0)
        
        // Iterates through the provided heartRateValue LinkedList.
        for currentHeartRateDataPoint in heartRateValue {
            // If we have found a new peak heart rate, set this as the contraction peak HR.
            if(contractionPeakHR.getHeartRateValue() < currentHeartRateDataPoint.value.getHeartRateValue()){
                contractionPeakHR = currentHeartRateDataPoint.value
            }
            
            if(isContractionOccuring){
                // If a contraction is occuring, check to see if the currently iterated upon value corresponds to the end of the contraction.
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

                    // Notifies the contraction driver that a new contraction has been detected for processing by the ML model.
                    let notificationName = Notification.Name("ContractionOccurredNotification")
                    NotificationCenter.default.post(name: notificationName, object: currentContractionValues)
                    
                    // Remove the stored values for the just found contraction and continue iterating over the LinkedList.
                    for _ in currentContractionValues{
                        currentContractionValues.pop()
                    }
                    continue
                }else {
                    // If the contraction is not ending, check to see if we have a new peak for the current contraction.
                    if(checkForPeakValue(current: currentHeartRateDataPoint.value.getHeartRateValue(), startHR: contractionStartDataPoint.getHeartRateValue())) {
                        contractionPeakHR = currentHeartRateDataPoint.value
                    }
                    currentContractionValues.append(currentHeartRateDataPoint.value)
                }
            }else {
                // If a contraction is detected to be occuring, this sets the isContractionOccuring state to true and begins recording the heart rate values.
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
    /**
     * Given a LinkedList of HeartRateDataPoints, determines the peak.
     *
     * @param heartRateDataPoints The LinkedList of HeartRateDataPoints to check.
     *
     * @returns Int An integer value represent the peak heart rate value.
     */
    private func determinePeakDuringContraction(heartRateDataPoints: LinkedList<HeartRateDataPoint>) -> Int{
        var peak = 0
        for heartRateDataPoint in heartRateDataPoints {
            if(heartRateDataPoint.value.getHeartRateValue() > peak){
                peak = heartRateDataPoint.value.getHeartRateValue()
            }
        }
        return peak
    }
    
    /**
     * Given a LinkedList of HeartRateDataPoints, determines if the trends in the data correspond to those representing the start of a contraction ( >= 6% HR increase).
     *
     * @param current The current heart rate value.
     * @param resting The resting heart rate value.
     *
     * @returns Bool A boolean denoting whether or not it is likely that a contraction has begun.
     */
    private func checkIfStartOfContraction(current: Int, resting: Int) -> Bool{
        let percent = 100 * (Double(current - resting) / Double(abs(resting)))
        if(percent >= 6){
            return true
        }
        return false
    }

    /**
     * Given a LinkedList of HeartRateDataPoints, determines if the trends in the data correspond to those representing the end of a contraction ( >= 6% HR decrease).
     *
     * @param current The current heart rate value.
     * @param resting The resting heart rate value.
     *
     * @returns Bool A boolean denoting whether or not it is likely that a contraction has ended.
     */
    private func checkIfEndOfContraction(peak: Int, current: Int) -> Bool{
        let percent = 100 * (Double(current - peak) / Double(abs(peak)))
        print("Percent ", percent, " ", current, " ", peak)
        if(percent <= -6){
            return true
        }
        return false
    }
    
    /**
     * Checks for a > %9 heart rate jump given the current heart rate and the start-of-contraction heart rate.
     *
     * @param current The current heart rate value.
     * @param startHR The starting heart rate of the contraction.
     *
     * @returns Bool A boolean representing whether there was a > 9% increase in the two heart rate values.
     */
    public func checkForPeakValue(current: Int, startHR: Int) -> Bool{
        let percent = 100 * (Double(startHR - current) / Double(abs(startHR)))
        if(percent >= 9){
            return true
        }
        return false
    }
}

//
//  MarkerWindow.swift
//  GetRide
//
//  Created by Ferrakkem Bhuiyan on 2021-01-08.
//

import UIKit

protocol MapMarkerDelegate: class {
    func didTapInfoButton(data: NSDictionary)
}

class MarkerWindow: UIView {
    
    @IBOutlet weak var tripId: UILabel!
    @IBOutlet weak var driverId: UILabel!
    @IBOutlet weak var passengerMiliges: UILabel!
    @IBOutlet weak var direction: UILabel!
    @IBOutlet weak var driverMiles: UILabel!
    @IBOutlet weak var date: UILabel!
    
    weak var delegate: MapMarkerDelegate?
    var spotData: NSDictionary?
    
    //MARK: - Setup values
    func setCellWithValuesOf(with markerData :RealmDataModel) {
        //print(markerData.trip_date
        
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        
        let dateInfo = getDate(unixdate: markerData.trip_date, timezone: localTimeZoneAbbreviation)
        //print(dateInfo)
        
        upDateUI(trip_Id: markerData.trip_id, driver_Id: markerData.driver_id, passenger_Miliges: markerData.passenger_miles, direction: markerData.direction, driver_Miles: markerData.driver_miles, date: dateInfo)
    }
    
    //MARK: - Update UI for marker statistics
    func upDateUI(trip_Id: String, driver_Id: String, passenger_Miliges: Double, direction: String, driver_Miles: Double, date: String){
        self.tripId.text = "Trip Id: \(trip_Id)"
        self.driverId.text = "Driver Id: \(driver_Id)"
        self.passengerMiliges.text = String("P Milies: \(passenger_Miliges)")
        self.direction.text = "Direction: \(direction)"
        self.driverMiles.text = String("D Milies: \(driver_Miles)")
        self.date.text = String("Date: \(date)")
        
    }
    
    func getDate(unixdate: Int, timezone: String) -> String {
        //if unixdate == 0 {return EMPTY_STRING}
        let date = NSDate(timeIntervalSince1970: TimeInterval(unixdate))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd-MMMM-YYYY"
        dayTimePeriodFormatter.timeZone = NSTimeZone(name: timezone) as TimeZone?
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return "\(dateString)"
    }
}


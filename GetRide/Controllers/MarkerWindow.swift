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
    
    
    func upDateUI(tripId: String, driverId: String, passengerMiliges: String, direction: String, driverMiles: String){
        self.tripId.text = tripId
        self.driverId.text = driverId
        self.passengerMiliges.text = passengerMiliges
        self.direction.text = direction
        self.driverMiles.text = driverMiles
    }
}

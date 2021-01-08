//
//  RealmDataModel.swift
//  GetRide
//
//  Created by Ferrakkem Bhuiyan on 2021-01-07.
//

import Foundation
import RealmSwift


class RealmDataModel: Object{
    //@objc dynamic var id: Int = 0
    @objc dynamic var trip_id: String = ""
    @objc dynamic var direction: String = ""
    @objc dynamic var passenger_miles: Double = 0.0
    @objc dynamic var driver_id: String = ""
    @objc dynamic var driver_miles: Double = 0.0
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var long: Double = 0.0
    @objc dynamic var trip_date: Int = 0
    
    override class func primaryKey() -> String {
        return "trip_id"
    }
}

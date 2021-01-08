//
//  TripsModel.swift
//  GetRide
//
//  Created by Ferrakkem Bhuiyan on 2021-01-06.
//

import Foundation

// MARK: - TripsModel
struct TripsModel: Codable {
    let responseCode: Int
    let executedVersion, message: String
    let payload: [Payload]
    
    enum CodingKeys: String, CodingKey {
        case responseCode = "ResponseCode"
        case executedVersion = "ExecutedVersion"
        case message = "Message"
        case payload = "Payload"
    }
}

// MARK: - Payload
struct Payload: Codable {
    let direction: String
    let passengerMiles: Double
    let driverID: String
    let driverMiles: Double
    let startLocation: [Double]
    let tripID: String
    let tripDate: Int
    
    enum CodingKeys: String, CodingKey {
        case direction
        case passengerMiles = "passenger_miles"
        case driverID = "driver_id"
        case driverMiles = "driver_miles"
        case startLocation = "start_location"
        case tripID = "trip_id"
        case tripDate = "trip_date"
    }
}


//
//  K.swift
//
//
//  Created by Ferrakkem Bhuiyan on 2020-08-30.
//  Copyright © 2020 Ferrakkem Bhuiyan. All rights reserved.
//


struct K{
    //MARK: - News Feed Table
    static let googleMapApiKey = ""
    
    struct MapZoom {
        static let minZoom: Float = 20.0
        static let maxZoom:Float = 25.0
        static let setZoomForRegion:Float = 10.0

    }
    
    struct TripRadious {
        static let tripSearchMinRadious = 0.34
        static let tripSearchMaxRadious = 3218.69
    }
    
    struct SetRegionLocation {
        static let lat = 43.621723
        static let long = -79.674583
    }
}

struct EndPoint {
    static let tripUrl = "https://5vb5vug3qg.execute-api.us-east-1.amazonaws.com/"
    struct RequestType {
        static let get_trip = "get_trip"
    }
}




//
//  ViewController.swift
//  GetRide
//
//  Created by Ferrakkem Bhuiyan on 2021-01-06.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    private var networkManager = NetworkManager()
    @IBOutlet weak var googleMapView: GMSMapView!
    
    private let locationManager = CLLocationManager()
    var tripData = [RealmDataModel]()
    var isDriver: Bool = false
    var isPassenger: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //call_checkInternetConnectivity
        checkInternetConnectivity()
        
        //check isLocation services on of off
        isLocationAccessEnabled()
        
       // googleMapView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
        
    //MARK: - Load Data
    func loadData(){
        networkManager.getTripsdata {(result) in
            switch result{
            case .success(let listOf):
                listOf.payload .forEach { (trip) in
                    DatabaseManager.shared.saveTripInfo(direction: trip.direction, passenger_miles: trip.passengerMiles, driver_id: trip.driverID, driver_miles: trip.driverMiles, lat: trip.startLocation[0], long: trip.startLocation[1], trip_id: trip.tripID, trip_date: trip.tripDate)
                    self.showAllLocation()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func showAllLocation(){
        //self.googleMapView.clear()
        
        var bounds = GMSCoordinateBounds()
        if isDriver{
            tripData = DatabaseManager.shared.driverMiles()
        }else if isPassenger {
            tripData = DatabaseManager.shared.passengerMiles()
        }else{
            
            tripData = DatabaseManager.shared.getTripInfo()
        }
        for data in tripData{
            let lat = data.lat
            let long = data.long
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            marker.map = googleMapView
            marker.icon = UIImage(named: "car")
            marker.title = String("Direction: \(data.direction)")
            marker.snippet = String("Driver id: \(data.driver_id)")
            marker.accessibilityLabel = "\(data)"
            bounds = bounds.includingCoordinate(marker.position)
        }
        
        googleMapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 40.0))
        self.perform(#selector(zoom), with: nil, afterDelay: 1.0)
        
        if tripData.count == 1{
            googleMapView.animate(toZoom: K.MapZoom.maxZoom)
        }else{
            googleMapView.animate(toZoom: K.MapZoom.maxZoom)
        }
    }
    
    //MARK: - ForZOOMIN
    @objc func zoom() {
        CATransaction.begin()
        CATransaction.setValue(1, forKey: kCATransactionAnimationDuration)
        // It will animate your camera to the specified lat and long
        let camera = GMSCameraPosition.camera(withLatitude: K.SetRegionLocation.lat , longitude: K.SetRegionLocation.long, zoom: K.MapZoom.setZoomForRegion)
        googleMapView.animate(to: camera)
        CATransaction.commit()
    }
    
    
    //MARK: - kInternetConnectivity check
    func checkInternetConnectivity(){
        let isConnection = InternetConnectionManager.isConnectedToNetwork()
        
        if isConnection{
            loadData()
        }else{
            //print("Not Connected")
            self.createSettingsAlertController(title: "Internet Services Off", message: "")
        }
    }
    
    //MARK: - calculateDistanceInMeter
    func calculateDistanceInMeter(location1:CLLocation, location2:CLLocation) -> Double{
        let distanceInMeters = location1.distance(from: location2)
        return abs(Double(round(1000000*distanceInMeters)/1000000))
    }
    
    //MARK: - initializeTheLocationManager
    func initializeTheLocationManager() {
        loadData()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locationManager.location?.coordinate
        print("location \(String(describing: location))")
        //cameraMoveToLocation(toLocation: location)
        self.locationManager.stopUpdatingLocation()
    }
    
    //MARK: - is location enable or not
    func isLocationAccessEnabled(){
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
            self.createSettingsAlertController(title: "Location Services Off", message: "")
        }
    }
    
    @IBAction func filterResults(_ sender: UIBarButtonItem) {
        self.openAlert(title: "Filter", message: "", alertStyle: .actionSheet, actionTitles: ["Driver Miles"," Passenger Miles", "Cancel"], actionStyles:[.default, .default,.cancel], actions: [
            {_ in
                self.isDriver = true
                self.isPassenger = false
                self.showAllLocation()
            },
            {_ in
                self.isDriver = false
                self.isPassenger = true
                self.showAllLocation()
            },
            {_ in
                self.isDriver = false
                self.isPassenger = false
                self.showAllLocation()
                //print("cancel")
            }
        ])
    }
    
}

extension ViewController: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
    
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 100))
        view.backgroundColor = UIColor.white
        view.layer.opacity = 1.0
        view.layer.cornerRadius = 6
        
        let title = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.width - 16, height: 15))
        title.tintColor = UIColor.brown
        
        let driverMiles = UILabel(frame: CGRect.init(x: 8, y: title.bounds.height + 10, width:view.frame.width - 16, height: 15))
        driverMiles.tintColor = UIColor.brown
        
        let passengerMiles = UILabel(frame: CGRect.init(x: 8, y: driverMiles.bounds.height + 10, width:view.frame.width - 16, height: 15))
        passengerMiles.tintColor = UIColor.brown
        
        
        tripData .forEach { (res) in
            //direction.text = String("Trip Id: \(res.direction)")
            title.text = String("Trip Id: \(res.trip_id)")
            driverMiles.text = String("Driver Miles: \(res.driver_miles)")
            passengerMiles.text = String("Driver Miles: \(res.passenger_miles)")
        }
        
        //view.addSubview(direction)
        view.addSubview(driverMiles)
        view.addSubview(title)
        return view
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
    }
    
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
}

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
        
        googleMapView.delegate = self
        
        
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
        //start loading
        self.LoadingStop()
        
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
            marker.userData = data
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
            self.LoadingStart()
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
                self.LoadingStop()
                self.showAllLocation()
            },
            {_ in
                
                self.isDriver = false
                self.isPassenger = true
                self.LoadingStop()
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

//MARK: - GMSMapViewDelegate
extension ViewController: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = Bundle.main.loadNibNamed("MarkerWindow", owner: self, options: nil )![0] as! MarkerWindow
        let frame = CGRect(x: 10, y: 10, width: 200, height: view.frame.height)
        view.frame = frame
        view.layer.cornerRadius = 6.0
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        view.setCellWithValuesOf(with: marker.userData as! RealmDataModel)
        return view
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
    }
    
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
}



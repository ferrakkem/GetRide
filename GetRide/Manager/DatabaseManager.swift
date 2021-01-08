//
//  NewsViewModel.swift
//  CBCMedia
//
//  Created by Ferrakkem Bhuiyan on 2020-12-06.
//

import RealmSwift

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let realm = try! Realm()
    var news: Results<RealmDataModel>?
    
    // MARK: - Lifecycle
    private init() {}
    
    // MARK: - Delete Realm Objects
    func delete() {
        try! realm.write {
          realm.deleteAll()
        }
    }
    
    //MARK: - Saving favourite gip
    func saveTripInfo(direction: String, passenger_miles: Double,  driver_id: String, driver_miles: Double , lat:Double, long: Double, trip_id: String,  trip_date: Int){
        
        let isExists = objectExists(id: trip_id)
        if isExists{
            //print("isExists")
        }else{
            //print("insert")
            let tripInfo = RealmDataModel()
            tripInfo.direction = direction
            tripInfo.passenger_miles = passenger_miles
            tripInfo.driver_id = driver_id
            tripInfo.driver_miles = driver_miles
            tripInfo.lat = lat
            tripInfo.long = long
            tripInfo.trip_id = trip_id
            tripInfo.trip_date = trip_date
            save(with: tripInfo)
        }
    }
    
    //MARK: - check is object Exists or not
    func objectExists(id: String) -> Bool{
        return realm.object(ofType: RealmDataModel.self, forPrimaryKey: id) != nil
    }
    
    //MARK: - Saving data
    func save(with tripDataInfo: RealmDataModel){
        do{
            try realm.write{
                realm.add(tripDataInfo)
                //realm.add(gipy, update: Realm.UpdatePolicy.modified)
            }
        }catch{
            print("Error during saving time: \(error)")
        }
    }
        
    //MARK: - loadNews
    func getTripInfo() -> [RealmDataModel]{
        return Array(realm.objects(RealmDataModel.self))
    }
    
    //MARK: - sorted_driverMiles
    func driverMiles() -> [RealmDataModel]{
        let value = (realm.objects(RealmDataModel.self).sorted(byKeyPath: "driver_miles", ascending: false)).prefix(5)
        return Array(value)
    }
    
    //MARK: - sorted_passengerMiles
    func passengerMiles() -> [RealmDataModel]{
        let value = (realm.objects(RealmDataModel.self).sorted(byKeyPath: "passenger_miles", ascending: false)).prefix(5)
        return Array(value)
    }
    
}

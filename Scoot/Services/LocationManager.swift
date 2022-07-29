//
//  LocationManager.swift
//  Scoot
//
//  Created by Luka Vujnovac on 26.07.2022..
//

import Foundation
import CoreLocation

struct Location {
    let title: String
    let coordinates: CLLocationCoordinate2D?
}

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    public func findLocations(with query: String, completition: @escaping (([Location]) -> Void)) {
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(query) { places, error in
            guard let places = places, error == nil else {
                completition([])
                return
            }
            
            let models: [Location] = places.compactMap { place in 
                var name = ""
                
                if let throughFare = place.thoroughfare {
                    name += throughFare + ", "
                }
                if let subThroughFare = place.subThoroughfare {
                    name += subThroughFare + ", "
                }
                if let locality = place.locality {
                    name += locality + ", "
                }
                if let country = place.country {
                    name += country + ", "
                }
                if let postalCode = place.postalCode {
                    name += postalCode + " "
                }
                
                print(place)
                
                let result = Location(title: name, coordinates: place.location?.coordinate)
                
                return result
            }
            
            completition(models)
        }
    }
    
    public func getAddressFromLatLon(pdblLatitude: String?, withLongitude pdblLongitude: String?){
        guard let pdblLatitude = pdblLatitude, let pdblLongitude = pdblLongitude else { return }
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        let lat: Double = Double("\(pdblLatitude)")!
        
        let lon: Double = Double("\(pdblLongitude)")!
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            guard let pm = placemarks as? [CLPlacemark] else {return}
            
            if pm.count > 0 {
                let pm = placemarks![0]
                var addressString : String = ""
                //ulica
                if pm.thoroughfare != nil {
                    addressString += pm.thoroughfare! + ", "
                }
                //broj ulice
                if pm.subThoroughfare != nil {
                    addressString += pm.subThoroughfare! + ", "
                }
                //grad
                if pm.locality != nil {
                    addressString += pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString += pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString += pm.postalCode! + " "
                }
//                self.locationString = addressString
                UserDefaults.standard.setLocation(location: addressString)
            }
        })
    }
    
    var locationLon = CLLocationDegrees(0)
    var locationLat = CLLocationDegrees(0)
    
    public func getDistance(for vehicle: VehicleResponse) -> String {
        let vehicleLocationLat = CLLocationDegrees(vehicle.location.locationPoint.lat)
        let vehicleLocationLon = CLLocationDegrees(vehicle.location.locationPoint.long)
        
        let vehicleLocation = CLLocation(latitude: vehicleLocationLat, longitude: vehicleLocationLon)
        
        let location = CLLocation(latitude: locationLat, longitude: locationLon)
        
        let distanceInMeters = vehicleLocation.distance(from: location)
        
//        print("\(distanceInMeters)")
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        
        return "\(formatter.string(from: distanceInMeters / 1000 as NSNumber) ?? "0") km away"
    }
}

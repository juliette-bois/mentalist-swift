//
//  LocationManager.swift
//  Mentalist
//
//  Created by Juliette Bois on 16.02.21.
//

import Foundation
import CoreLocation


class LocationManager: NSObject {
    
    override init() {
        super.init()
    }
}

extension LocationManager {
    func getLocation(forPlaceCalled name: String, completion: @escaping(CLLocation?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            guard let location = placemark.location else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }

            completion(location)
        }
    }
}

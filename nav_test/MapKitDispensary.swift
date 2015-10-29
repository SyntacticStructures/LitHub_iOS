//
//  MapKitDispensary.swift
//  LitHub
//
//  Created by Computer on 10/28/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation
import MapKit

class mkDispensary: NSObject, MKAnnotation {
    var title: String?
    var isMedical: Bool?
    var id: Int
    var name: String
    var address: String
    var city: String
    var state: String
    var latitude: Double
    var longitude: Double
    var phone: String
    var logo: String
    var distance: Double
    //var hours: String
    
    init(title: String, isMedical: Bool, id: Int, name: String, address: String, city: String, latitude: Double, longitude: Double, state: String, phone: String, distance: Double, logo: String) {
        self.title = name
        self.id = id
        self.name = name
        self.address = address
        self.city = city
        self.state = state
        self.latitude = latitude
        self.longitude = longitude
        self.phone = phone
        self.distance = distance
        self.logo = logo
    }
    @objc var coordinate:CLLocationCoordinate2D {
        let coord = CLLocationCoordinate2DMake(latitude, longitude)
        return coord
    }
    var subtitle: String? {
        //        here we can use this function to generate subtitle from aything in class
        return name
    }
}
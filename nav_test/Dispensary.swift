//
//  Dispensary.swift
//  nav_test
//
//  Created by mac on 9/14/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation

class Dispensary: NSObject {
    var title: String?
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
    
    init(title: String, id: Int, name: String, address: String, city: String, latitude: Double, longitude: Double, state: String, phone: String, distance: Double, logo: String) {
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
    
    var subtitle: String? {
        //        here we can use this function to generate subtitle from aything in class
        return name
    }
}
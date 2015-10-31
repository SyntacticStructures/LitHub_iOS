//
//  Reservation.swift
//  LitHub
//
//  Created by mac on 10/21/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation

class Reservation {
    var id : Int?
    var status: String
    var vendor: String
    var vendorID: Int
    var strainName: String
    var strainID: Int
    var priceGram: Double
    var priceEigth: Double
    var priceQuarter: Double
    var priceHalf: Double
    var priceOz: Double
    var quantityGram: Int
    var quantityEigth: Int
    var quantityQuarter: Int
    var quantityHalf: Int
    var quantityOz: Int
    
    init(status: String, vendor: String, vendorID: Int, strainName: String, strainID: Int, priceGram: Double, priceEigth: Double, priceQuarter: Double, priceHalf: Double, priceOz: Double, quantityGram: Int, quantityEigth: Int, quantityQuarter: Int, quantityHalf: Int, quantityOz: Int) {
        //self.id = id
        self.status = status
        self.vendor = vendor
        self.vendorID = vendorID
        self.strainName = strainName
        self.strainID = strainID
        self.priceGram = priceGram
        self.priceEigth = priceEigth
        self.priceQuarter = priceQuarter
        self.priceHalf = priceHalf
        self.priceOz = priceOz
        self.quantityGram = quantityGram
        self.quantityEigth = quantityEigth
        self.quantityQuarter = quantityQuarter
        self.quantityHalf = quantityHalf
        self.quantityOz = quantityOz
    }

}

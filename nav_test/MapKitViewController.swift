//
//  MapViewController.swift
//  nav_test
//
//  Created by mac on 9/15/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import MapKit
import FontAwesome_swift

class MapkitViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var dispensaries = [mkDispensary]()
    var cameraLocation: CLLocationCoordinate2D?
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var locationArray = [CLLocation]()
    @IBOutlet weak var mapView: MKMapView!
    var logo : UIImage?
    var requestImage = true;
    var medicalButtonOutlet = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
            if let location = locationManager.location {
                self.currentLocation = location
                let zoom = CLLocationDistance(20000)
                let locationCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                drawMarkersForDispensariesNear(currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                self.zoomTo(self.currentLocation.coordinate, zoom: 500)
                self.view = self.mapView
                self.view.addSubview(self.medicalButtonOutlet)
                // draw the current location button
                let selector = "userLocation:" as Selector
                self.drawButton("location", buttonAction: selector)
            }
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            print("ap view draws  for standard user loap view draws blue dot for standard user lo")
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin")
        //    check if it's dequeueable. Apple docs recommend this to conserve memory
        var imgStr = String()
        //    let imageChecker = annotation as! mkDispensary
        if pinView == nil {
            imgStr = "weedpin"
            let identifier = "pin"
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinView!.canShowCallout = true
            pinView!.calloutOffset = CGPoint(x: -5, y: 5)
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            pinView!.image = UIImage(named: imgStr)
        }
            //if it's already on the map, draw it as is
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            print("disclosure clicked")
            let sender = annotationView.annotation
            self.performSegueWithIdentifier("ShowMenu", sender: sender)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "ShowMenu") {
            let menuViewController = (segue.destinationViewController as! MenuViewController)
            menuViewController.dispensary = (sender as! mkDispensary)
        }
    }
    
    func drawMarkersForDispensariesNear(latitude: Double, longitude: Double) {
        print(latitude)
        print(longitude)
        let string = "http://getlithub.com/dispensaries?lat=\(latitude)&lng=\(longitude)"
        //print(string)
        Alamofire.request(.GET, string)
            .responseJSON { response in
                print("here")
                if response.result.isSuccess {
                    let arrayOfDispensaries = JSON(response.result.value!)
                    print("this is the object returned", response);
                    //print(arrayOfDispensaries)
                    for var i = 0; i < arrayOfDispensaries.count; ++i {
                        let dispensaryId = arrayOfDispensaries[i]["id"].int
                        let dispensaryName = arrayOfDispensaries[i]["name"].string
                        let dispensaryLat = arrayOfDispensaries[i]["lat"].double
                        let dispensaryLng = arrayOfDispensaries[i]["lng"].double
                        let dispensaryAdd = arrayOfDispensaries[i]["address"].string
                        let dispensaryState = arrayOfDispensaries[i]["State"].string
                        let dispensaryCity = arrayOfDispensaries[i]["City"].string
                        let dispensaryPhone = arrayOfDispensaries[i]["phone"].string
                        let dispensaryLogo = arrayOfDispensaries[i]["logo"].string
                        //                        we need an attribute for isMedical so we can display different pins. For now, I'll make every 7th dispensary medical. I do that in the annotation view class
                        //distance set to maxRadius on node backend = 5000
                        let dispensaryDistance = arrayOfDispensaries[i]["distance"].double
                        let dispensary = mkDispensary(title: dispensaryName!, id: dispensaryId!, name: dispensaryName!, address: dispensaryAdd!, city: dispensaryCity!, latitude: dispensaryLat!, longitude: dispensaryLng!, state: dispensaryState!, phone: dispensaryPhone!, distance: 0.0, logo: dispensaryLogo!)
                        dispensary.latitude = dispensaryLat!
                        dispensary.longitude = dispensaryLng!
                        dispensary.distance = dispensaryDistance!
                        
                        
                        
                        self.dispensaries.append(dispensary)
                        //draw markers
                        self.mapView.addAnnotations(self.dispensaries)
                        
                    }
                    print(self.dispensaries.count)
                    //case .Failure(_, let error):
                } else {
                    print("Request failed with error:\(response.result.error)")
                    
                }
        }//Alamo end
    }
    
    //    func getDistanceOfDispensariesWhere(Double: latitude, Double: longitude) {
    //
    //    }
    //    we have to make this button programatically. might be able to do it with delegate instead..
    func drawButton(imageName: String, buttonAction: Selector){
        //        let imageOn = UIImage(named:imageName)
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        let button = UIButton(type: .System) as UIButton
        // Change frame
        button.frame = CGRectMake(0, 0, 42, 42)
        // Change center of button
        button.center = CGPoint(x: screenWidth/7, y: screenHeight/1.45)
        button.titleLabel?.font = UIFont.fontAwesomeOfSize(40)
        button.setTitle(String.fontAwesomeIconWithName(.LocationArrow), forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
//        button.frame = CGRectMake(10, 10, 75, 69)
        //        button.setBackgroundImage(imageOn, forState: .Normal)
        button.addTarget(self, action: "userLocation:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    
    //  method for location arrow tap
    @IBAction func userLocation(sender:UIButton)
    {
        print("Button Action From Code")
        self.zoomTo(self.currentLocation.coordinate, zoom: 500)
    }
    
    func drawMenu(){
        //        let imageOn = UIImage(named:"medicalOn")
        let label = UILabel()
        label.frame = CGRectMake(100, 100, 100, 100)
        //        label.setBackgroundImage(imageOn, forState: .Normal)
        label.text = "poop"
        //        label.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(label)
    }
    //medicalButton
    //    func buttonAction(sender:UIButton!) {
    //        print("Button tapped")
    //        if sender.backgroundImageForState(.Normal) == UIImage(named:"medicalOn") {
    //            let image = UIImage(named:"medicalOff")
    //            sender.setBackgroundImage(image, forState: .Normal)
    //            print("yup")
    //            self.refreshAnnotations(0)
    //        } else if sender.backgroundImageForState(.Normal) == UIImage(named: "medicalOff") {
    //            let image = UIImage(named:"medicalOn")
    //            sender.setBackgroundImage(image, forState: .Normal)
    //            self.refreshAnnotations(1)
    //        }
    //
    //    }
    func zoomTo(locationCoordinate: CLLocationCoordinate2D, zoom: CLLocationDistance) {
        let region = MKCoordinateRegionMakeWithDistance(
            locationCoordinate, zoom, zoom)
        mapView.setRegion(region, animated: true)
    }
    func drawLabel() {
        let label = UILabel()
        label.text = "loading..."
        label.backgroundColor = UIColor.whiteColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.Center
        label.layer.cornerRadius = 5
        label.tag = 10010
        // newView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(label)
        let horizontalConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 300)
        label.addConstraint(widthConstraint)
        // view.addConstraint(widthConstraint) // also works
        
        let heightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30)
        label.addConstraint(heightConstraint)
        // view.addConstraint(heightConstraint) // also works
        //        self.view.viewWithTag(10010)!.hidden = true
    }
    
    //    func zoomToSeattle() {
    //        let seattleArea = CLLocationCoordinate2D(
    //            latitude: 47.60616304, longitude: -122.21466064)
    //        let region = MKCoordinateRegionMakeWithDistance(
    //            seattleArea, 30000, 30000)
    //        mapView.setRegion(region, animated: true)
    //    }
    
    //    func refreshAnnotations(identifier: Int) {
    //        //            self.mapView.annotations is get-only, so self.mapview.annotations.removeAll() will not work
    //        if identifier == 0 {
    ////            if we want no medical
    //            self.mapView.removeAnnotations(self.mapView.annotations)
    //            for dispensary in self.dispensaries {
    //                if dispensary.isMedical! {
    //                    self.mapView.addAnnotation(dispensary)
    //                }
    //            }
    //        } else {
    ////            if we don't want medical
    //            self.mapView.removeAnnotations(self.mapView.annotations)
    //            for dispensary in self.dispensaries {
    //                if !dispensary.isMedical! {
    //                    self.mapView.addAnnotation(dispensary)
    //                }
    //            }
    //        }
    //    }
    
    func parseJSON(inputData: NSData) -> NSArray? {
        do {
            var arrOfObjects = try NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            return arrOfObjects
        } catch {
            print(error)
            return nil
        }
    }
}



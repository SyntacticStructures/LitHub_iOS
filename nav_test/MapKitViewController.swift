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
        locationManager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
            if let location = locationManager.location {
                self.currentLocation = location
                drawMarkersForDispensariesNear(currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                self.zoomToSeattle()
            }
        }
        
        self.view = self.mapView
        self.view.addSubview(self.medicalButtonOutlet)
        self.drawButton()
        
    }
    
//    I don't think we need this. saving it until more of this controller is stable -- Taylor
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        //print("here")
//        if status == .AuthorizedWhenInUse {
//            locationManager.startUpdatingLocation()
//        }
//    }
//    I also dont think we need this. Same reason as above
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
//            locationManager.stopUpdatingLocation()
//        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
//    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker!) {
//        dispatch_async(dispatch_get_main_queue()) {
//            self.performSegueWithIdentifier("ShowMenu", sender: marker)
//        }
//    }
    
//    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker!) -> Bool {
//        mapView.selectedMarker = marker
//        return true
//    }
    
    
func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation {
        print("ap view draws  for standard user loap view draws blue dot for standard user lo")
        //return nil so map view draws "blue dot" for standard user location
        return nil
    }
    var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin")
    //    check if it's dequeueable. Apple docs recommend this to conserve memory
    var imgStr = String()
    let imageChecker = annotation as! mkDispensary
    if pinView == nil {
        if imageChecker.isMedical == false {
            imgStr = "weedpin"
        } else if imageChecker.isMedical == true {imgStr = "medpin"}
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

override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
func drawMarkersForDispensariesNear(latitude: Double, longitude: Double) {
    print(latitude)
    print(longitude)
    let string = "http://getlithub.com/dispensaries?lat=\(latitude)&lng=\(longitude)"
    //print(string)
    Alamofire.request(.GET, string)
        .responseJSON { response in
            if response.data != nil {
                print("data is not nil")
                //case .Success(let data):
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
                        let dispensary = mkDispensary(title: dispensaryName!, isMedical: Bool(), id: dispensaryId!, name: dispensaryName!, address: dispensaryAdd!, city: dispensaryCity!, latitude: dispensaryLat!, longitude: dispensaryLng!, state: dispensaryState!, phone: dispensaryPhone!, distance: 0.0, logo: dispensaryLogo!)
                        dispensary.latitude = dispensaryLat!
                        dispensary.longitude = dispensaryLng!
                        dispensary.distance = dispensaryDistance!
                        
                        let rand = arc4random_uniform(7)
                        if rand == 5 {
                            dispensary.isMedical = true
                        } else {
                            dispensary.isMedical = false
                        }
                        

                        self.dispensaries.append(dispensary)
                        //draw markers
                        self.refreshAnnotations(2)
                        
                    }
                    print(self.dispensaries.count)
                //case .Failure(_, let error):
            } else {
                print("Request failed with error:")
                
            }
        }//Alamo end
}
    
//    func getDistanceOfDispensariesWhere(Double: latitude, Double: longitude) {
//        
//    }
//    we have to make this button programatically. might be able to do it with delegate instead..
    func drawButton(){
        let imageOn = UIImage(named:"medicalOn")
        let button = UIButton()
        button.frame = CGRectMake(10, 10, 75, 69)
        button.setBackgroundImage(imageOn, forState: .Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button)
    }
    
    func buttonAction(sender:UIButton!)
    {
        print("Button tapped")
        if sender.backgroundImageForState(.Normal) == UIImage(named:"medicalOn") {
            let image = UIImage(named:"medicalOff")
            sender.setBackgroundImage(image, forState: .Normal)
            print("yup")
            self.refreshAnnotations(0)
        } else if sender.backgroundImageForState(.Normal) == UIImage(named: "medicalOff") {
            let image = UIImage(named:"medicalOn")
            sender.setBackgroundImage(image, forState: .Normal)
            self.refreshAnnotations(1)
        }
    
    }
    func zoomToSeattle() {
        let seattleArea = CLLocationCoordinate2D(
            latitude: 47.60616304, longitude: -122.21466064)
        let region = MKCoordinateRegionMakeWithDistance(
            seattleArea, 60000, 60000)
        mapView.setRegion(region, animated: true)
    }
    
    func refreshAnnotations(identifier: Int) {
        //            self.mapView.annotations is get-only, so self.mapview.annotations.removeAll() will not work
        if identifier == 0 {
            self.mapView.removeAnnotations(self.mapView.annotations)
            for dispensary in self.dispensaries {
                if dispensary.isMedical! {
                    self.mapView.addAnnotation(dispensary)
                }
            }
        } else {
            self.mapView.removeAnnotations(self.mapView.annotations)
            for dispensary in self.dispensaries {
                if !dispensary.isMedical! {
                    self.mapView.addAnnotation(dispensary)
                }
            }
        }
    }
    
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



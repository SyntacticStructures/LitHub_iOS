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
    var annotations = [MKAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            if let location = locationManager.location {
                self.currentLocation = location
                drawMarkersForDispensariesNear(currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                self.zoomToSeattle()
            }
        }
        
        self.view = self.mapView
        
        
    }
//    I don't think we need this. saving it until more of this controller is stable -- Taylor
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        //print("here")
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
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
    if let annotation = annotation as? mkDispensary {
        let identifier = "pin"
        var view = MKAnnotationView()
//        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//            //                SET THE IMAGE last!
////            let url = NSURL(string: annotation.logo)
////            let data = NSData(contentsOfURL: url!)
////            view.logo = UIImage(data: data!)
//        } else {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            view.image = UIImage(named: "leaficon")
//            let url = NSURL(string: annotation.logo)
//            let data = NSData(contentsOfURL: url!)
//            view.logo = UIImage(data: data!)
//        }
        return view
    }
    print("returning nil")
    return nil
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
                print("Request failed with error:")
                
            }
        }//Alamo end
}
    
//    func getDistanceOfDispensariesWhere(Double: latitude, Double: longitude) {
//        
//    }


    func zoomToSeattle() {
        let seattleArea = CLLocationCoordinate2D(
            latitude: 47.60616304, longitude: -122.21466064)
        let region = MKCoordinateRegionMakeWithDistance(
            seattleArea, 60000, 60000)
        mapView.setRegion(region, animated: false)
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



//
//  ViewController.swift
//  Memorable Places
//
//  Created by Yisen on 6/20/15.
//  Copyright (c) 2015 Yisen. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var manager:CLLocationManager!

    @IBOutlet weak var map: MKMapView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        map.mapType = MKMapType.Satellite
        
        
        
        if activePlace == -1 {
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        } else {
            let latitude = NSString(string: places[activePlace]["lat"]!).doubleValue
            let longitude = NSString(string: places[activePlace]["lon"]!).doubleValue
            
            var coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            
            var latDelta: CLLocationDegrees = 0.01
            var lonDelta: CLLocationDegrees = 0.01
            
            var span: MKCoordinateSpan =  MKCoordinateSpanMake(latDelta, lonDelta)
            var region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
            
            self.map.setRegion(region, animated: true)
            
            var annotation = MKPointAnnotation()
            
            annotation.coordinate = coordinate
            
            annotation.title = places[activePlace]["name"]
            
            self.map.addAnnotation(annotation)
            
        }
        


        
        
        var uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 1
        
        map.addGestureRecognizer(uilpgr)
        
    }
    
    
    func action(gestureRecognizer:UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            var touchPoint = gestureRecognizer.locationInView(self.map)
            
            var newCoodinate = self.map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            var location = CLLocation(latitude: newCoodinate.latitude, longitude: newCoodinate.longitude)
            
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                var title = ""
                
                if (error == nil) {
                    if let p = CLPlacemark(placemark: placemarks?[0] as! CLPlacemark)  {
                        var subThroughfare: String = ""
                        var thoughfare: String = ""
                        
                        if p.subThoroughfare != nil {
                            subThroughfare = p.subThoroughfare
                        }
                        
                        if p.thoroughfare != nil {
                            thoughfare = p.thoroughfare
                        }
                        
                        title = "\(subThroughfare) \(thoughfare)"
                        
                    }
        
                    
                }
 
                if title == "" {
                    title = "Added \(NSData())"
               }
                
                places.append(["name":title,"lat":"\(newCoodinate.latitude)","lon":"\(newCoodinate.longitude)"])
                
                println(places[places.count - 1])
                
                
                
                var annotation = MKPointAnnotation()
                
                annotation.coordinate = newCoodinate
                
                annotation.title = title
                
                self.map.addAnnotation(annotation)

            
            })
            
            
            
            
            
            
        }
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var userLocation:CLLocation = locations[0] as! CLLocation
        
        var latitude = userLocation.coordinate.latitude
        var longitude = userLocation.coordinate.longitude
        var coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        var latDelta: CLLocationDegrees = 0.01
        var lonDelta: CLLocationDegrees = 0.01
        
        var span: MKCoordinateSpan =  MKCoordinateSpanMake(latDelta, lonDelta)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
        self.map.setRegion(region, animated: true)
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  Map.swift
//  ProjectSquad
//
//  Created by Karen Oliver on 2/21/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

class Map: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var locationManager: CLLocationManager!
    var squadId: String =  ""
    var squadName: String = ""
    var annotationDict: [String: CustomPointAnnotation] = [:]
    var regionSet: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfExpired()
        map.delegate = self
        
        //Call checkIfExpired when app comes back to foreground
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(Map.checkIfExpired), name:
            UIApplicationWillEnterForegroundNotification, object: nil)
        
        self.squadId = NetManager.sharedManager.currentSquadData!.id
        self.squadName = NetManager.sharedManager.currentSquadData!.name
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.activityType = CLActivityType.Fitness
        locationManager.allowsBackgroundLocationUpdates = true
        
        let containerView = UIView()
        let arrow = UIImageView(image: UIImage(named: "ForwardArrow"))
        arrow.contentMode = .ScaleAspectFit
        let titleLabel = UILabel()
        titleLabel.font = Themes.Fonts.bigBold
        titleLabel.attributedText = NSAttributedString(string: squadName)
        titleLabel.kern(Themes.Fonts.kerning)
        titleLabel.textColor = Themes.Colors.light
        titleLabel.sizeToFit()
        
        arrow.frame = CGRect(x: titleLabel.frame.size.width, y: 4, width: titleLabel.frame.size.height, height: titleLabel.frame.size.height-8)
        containerView.frame.size.height = titleLabel.frame.size.height
        containerView.frame.size.width = titleLabel.frame.size.width + titleLabel.frame.size.height
        //containerView.userInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(Map.toSquadOverview))
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(arrow)
        
        self.navigationItem.titleView = containerView
        self.navigationItem.titleView?.userInteractionEnabled = true
        self.navigationItem.titleView?.addGestureRecognizer(tap)
    
    }
    
    override func viewDidAppear(animated: Bool) {
        self.regionSet = false
        
        NetManager.sharedManager.getSquad(squadId, block: {squad in
            for(memberName, memberId) in squad.members{
                NetManager.sharedManager.listenForLocationUpdates(memberId, block: { location in
                    let dropPin = CustomPointAnnotation()
                    dropPin.coordinate = location.coordinate
                    dropPin.title = memberName
                    dropPin.imageName = "LocationDotPink"
                    self.map.addAnnotation(dropPin)
                    if let val = self.annotationDict[memberId]{
                        self.map.removeAnnotation(val)
                    }
                    self.annotationDict[memberId] = dropPin
                    //
                    if(!self.regionSet){
                        if let val = self.annotationDict[NetManager.sharedManager.currentUserData!.uid]{
                            self.regionSet = true;
                            let region = self.findMapRegion()
                            self.map.setRegion(region, animated: true)
                        }
                    }

                    

                })
            }
        })
    }
    
    func checkIfExpired(){
        let now = NSDate()
        if(NetManager.sharedManager.currentSquadData!.endTime.compare(now) == .OrderedAscending){
            NetManager.sharedManager.leaveSquad({
                block in
                self.performSegueWithIdentifier("squadExpiredSegue", sender: nil)
            })
        }
    }

    func findMapRegion() -> MKCoordinateRegion{
        if(annotationDict.isEmpty){
            let locationCenter = CLLocationCoordinate2D(latitude: 34.4133, longitude: -119.861)
            return MKCoordinateRegionMake(locationCenter, MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        }
        else{
            var upper: CLLocationCoordinate2D?
            var lower: CLLocationCoordinate2D?
            for (_, annotation) in annotationDict{
                let coordLat = annotation.coordinate.latitude
                let coordLong = annotation.coordinate.longitude
                if(upper == nil || lower == nil){
                    upper = CLLocationCoordinate2D(latitude: coordLat, longitude: coordLong)
                    lower = CLLocationCoordinate2D(latitude: coordLat, longitude: coordLong)
                }else{
                    if(coordLat > upper!.latitude){
                        upper!.latitude = coordLat
                    }
                    if(coordLat < lower!.latitude){
                        lower!.latitude = coordLat
                    }
                    if(coordLong > upper!.longitude){
                        upper!.longitude = coordLong
                    }
                    if(coordLong < lower!.longitude){
                        lower!.longitude = coordLong
                    }
                }
            }
            
            var locationSpan: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
            let latDelta = upper!.latitude - lower!.latitude
            let lonDelta = upper!.longitude - lower!.longitude
            if(latDelta != 0.0){
                locationSpan.latitudeDelta = latDelta + 0.01
            }
            if(lonDelta != 0.0){
                locationSpan.longitudeDelta = lonDelta + 0.01
            }
            
            let locationCenter: CLLocationCoordinate2D = CLLocationCoordinate2DMake(((upper!.latitude + lower!.latitude) / 2), ((upper!.longitude + lower!.longitude) / 2))
            
            let region: MKCoordinateRegion = MKCoordinateRegionMake(locationCenter, locationSpan)
            return region;
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        //map.showsUserLocation = (status == .AuthorizedAlways)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        NetManager.sharedManager.updateCurrentLocation(locationObj)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation
        anView!.image = UIImage(named:cpa.imageName)
        
        return anView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toSquadOverview () {
        self.performSegueWithIdentifier("showSquadOverview", sender: nil)
    }

}

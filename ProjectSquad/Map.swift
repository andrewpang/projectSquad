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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        
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
    
    func checkIfExpired(){
        let now = NSDate()
        if(NetManager.sharedManager.currentSquadData!.endTime.compare(now) == .OrderedAscending){
            NetManager.sharedManager.leaveSquad({
                block in
                self.performSegueWithIdentifier("squadExpiredSegue", sender: nil)
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
//        let region = findMapRegion()
//        self.map.setRegion(region, animated: true)

        NetManager.sharedManager.getSquad(squadId, block: {squad in
            for(memberName, memberId) in squad.members{
//                let myname = NetManager.sharedManager.currentUserData?.displayName
//                let name = NetManager.sharedManager.currentSquadData?.name
//                print(name)
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
                    
                })
            }
        })
    }

    func findMapRegion() -> MKCoordinateRegion{
        if(annotationDict.isEmpty){
            let locationCenter = CLLocationCoordinate2D(latitude: 100, longitude: 100)
            return MKCoordinateRegionMake(locationCenter, MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
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
                    if(coordLat > upper!.longitude){
                        upper!.latitude = coordLat
                    }
                    if(coordLat < lower!.longitude){
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
            
            var locationSpan: MKCoordinateSpan?
            locationSpan!.latitudeDelta = upper!.latitude - lower!.latitude;
            locationSpan!.longitudeDelta = upper!.longitude - lower!.longitude;
            var locationCenter: CLLocationCoordinate2D?
            
            
            locationCenter!.latitude = (upper!.latitude + lower!.latitude) / 2;
            locationCenter!.longitude = (upper!.longitude + lower!.longitude) / 2;
            
            let region: MKCoordinateRegion = MKCoordinateRegionMake(locationCenter!, locationSpan)
            return region;
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        //map.showsUserLocation = (status == .AuthorizedAlways)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        NetManager.sharedManager.updateCurrentLocation(locationObj)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
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

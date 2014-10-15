//
//  ViewController.swift
//  SwiftMapControlsProg
//
//  Created by Colin Mackenzie on 08/10/2014.
//  Copyright (c) 2014 Colin Mackenzie. All rights reserved.
//
//  This version does not use the storyboard.

import UIKit
import MapKit


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{

    var mapView:            MKMapView!
    var plusButton:         UIButton!
    var minusButton:        UIButton!
    var mapSegmentControl:  UISegmentedControl!
 
    var location = CLLocation  (latitude: 0.0 as CLLocationDegrees, longitude: 0.0 as CLLocationDegrees)
    var location2D: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 0.0, 0.0)
    var myZoom = 6.4
    var annotion:MKAnnotation!
    var myPin:MapPin!
    
    var startX:CGFloat!
    var startY:CGFloat!
    var sizeX:CGFloat!
    var sizeY:CGFloat!
    var centre1:CGPoint = CGPointMake(0.0, 0.0)
    var centre2:CGPoint = CGPointMake(0.0, 0.0)
    
    let buttonSize:CGFloat = 60


    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        createUIItems()
        
        self.mapView.delegate = self
        /*
        Location = Berlin.
        */
        location   = CLLocation                 (latitude: 52.4545 as CLLocationDegrees, longitude: 13.46578 as CLLocationDegrees)
        location2D = CLLocationCoordinate2DMake (52.4545 as CLLocationDegrees, 13.46578 as CLLocationDegrees)
        
        addRadiusCircle (location)
        gotoPosition    (location2D)
        
        self.mapView.zoomEnabled   = true
        self.mapView.scrollEnabled = true
        self.mapView.rotateEnabled = true
        
        myPin = MapPin(coordinate: location2D, title: "Berlin", subtitle: "where we live")
        
        self.mapView.addAnnotation(myPin)

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize,
        withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
        /*
            Position our MapView, UIButtons and UISegmentedControl items.
        */
        
        var width = size.width
        var height = size.height
        //println("screen size \(width) \(height)")
        
        setVariables( width,height: height)
        

        if let map = mapView
        {
            mapView.bounds.size.width  = sizeX
            mapView.bounds.size.height = sizeY
            if width < height
            {
                // Portrait
                mapView.center = centre1
                //println("map center= \(centre1.x) \(centre1.y) size= \(sizeX) \(sizeY)")
            }
            else
            {
                // landscape
                mapView.center = centre2
                //println("map center= \(centre2.x) \(centre2.y) size= \(sizeX) \(sizeY)")
            }
        }
        
        if let plus = plusButton
        {
            plus.bounds.size.width  = buttonSize
            plus.bounds.size.height = buttonSize
            plus.center = CGPointMake(startX + buttonSize/2, startY + buttonSize/2)
            //println("+Button center= \(startX + buttonSize/2) \(startY + buttonSize/2) size= \(buttonSize) \(buttonSize)")
        }
        
        if let minus = minusButton
        {
            minus.bounds.size.width  = buttonSize
            minus.bounds.size.height = buttonSize
            minus.center = CGPointMake(startX + buttonSize/2, startY + buttonSize + buttonSize/2)
            //println("-Button center= \(startX + buttonSize/2) \(startY + buttonSize + buttonSize/2) size= \(buttonSize) \(buttonSize)")
        }
        
        if let mapSeg = mapSegmentControl
        {
            mapSeg.bounds.size.width  = width/2
            mapSeg.bounds.size.height = 22
            mapSeg.center = CGPointMake(startX + (width/4), startY + sizeY + 11)
            //println("mapSeg center= \(startX + (width/4)) \(startY + sizeY + 11) size= \(width/2) 22")
            
        }
    }
    

    func setVariables(width:CGFloat,height:CGFloat)
    {
        /*
            calculate the centre , start and size of map View.
            Leave 10% free. 5% each side.
        */
        let borderPCWidthHeight:CGFloat  = 10.0 / 200.0
        
        if width < height
        {
            // portrait
            centre1.x = width  / 2
            centre1.y = height / 2
            centre2.x = height / 2
            centre2.y = width  / 2
        }
        else
        {
            // landscape
            centre1.x = height / 2
            centre1.y = width  / 2
            centre2.x = width  / 2
            centre2.y = height / 2
        }
        startX = width * borderPCWidthHeight
        startY = height * borderPCWidthHeight
        sizeX  = width  - (startX*2)
        sizeY  = height - (startY*2)
        
        //println("centres \(centre1.x) \(centre1.y) \(centre2.x) \(centre2.y)")

    }
    
    func createUIItems()
    {
        /*
            create View smaller than actual screen size
            this version works in portrait and landscape.
        */
        
        var width = self.view.bounds.size.width
        var height = self.view.bounds.size.height
        //println("screen size \(width) \(height)")

        setVariables( width,height: height)
        
        //println("centres \(centre1.x) \(centre1.y) \(centre2.x) \(centre2.y)")

        
        /*
            Add map View.
        */
        mapView = MKMapView(frame:CGRectMake(startX,startY,sizeX,sizeY))
        println("mapview  \(startX) \(startY) \(sizeX) \(sizeY)")
        
        self.view.addSubview(mapView)
        
        var thiscentre = mapView.frame
        
        
        /*
            Add + button to zoom in
            add on top off the top left corner of MapView
        */
        plusButton = UIButton(frame: CGRectMake(startX,startY, buttonSize, buttonSize))
        plusButton.setTitle("+", forState: UIControlState.Normal)
        plusButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        plusButton.titleLabel?.font = UIFont.systemFontOfSize(30)
        plusButton.addTarget(self, action: "plusButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(plusButton)
        
        /*
            Add - button to zoom out
            add just below the + button
        */
        minusButton = UIButton(frame: CGRectMake(startX,startY + buttonSize, buttonSize, buttonSize))
        minusButton.setTitle("-", forState: UIControlState.Normal)
        minusButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        minusButton.titleLabel?.font = UIFont.systemFontOfSize(30)
        minusButton.addTarget(self, action: "minusButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(minusButton)
        
        /*
            Add segmented switch to change map type
            add below the Map View at bottom left.
        */
        mapSegmentControl = UISegmentedControl(frame: CGRectMake(startX,startY + sizeY, width/2, 25))
        mapSegmentControl.insertSegmentWithTitle("map", atIndex: 0,animated: true)
        mapSegmentControl.insertSegmentWithTitle("hybrid", atIndex: 1,animated: true)
        mapSegmentControl.insertSegmentWithTitle("satellite", atIndex: 2,animated: true)
        mapSegmentControl.addTarget(self, action: "mapSegmentPressed:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.view.addSubview(mapSegmentControl)
    }
    
    func gotoPosition(location2D: CLLocationCoordinate2D)
    {
        var span:MKCoordinateSpan = MKCoordinateSpanMake(myZoom, myZoom)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location2D, span)
        region.center = location2D
        
        self.mapView.region = region
    }
    
    func adjustZoom()
    {
        var location = mapView.region.center
        
        var newSpan:MKCoordinateSpan = MKCoordinateSpanMake(myZoom, myZoom)
        var newRegion = MKCoordinateRegionMake(location, newSpan)
        
        
        self.mapView.region = newRegion
    }
    
    
    func addRadiusCircle(location: CLLocation)
    {
        
        var circle = MKCircle(centerCoordinate: location.coordinate, radius: 10000 as CLLocationDistance)
        self.mapView.addOverlay(circle)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer!
    {
        if overlay is MKCircle
        {
            var circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.redColor()
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        }
        else
        {
            return nil
        }
    }
    
    
    
    func minusButtonPressed(sender:UIButton)
    {
        
        if myZoom < 55.0
        {
            myZoom = myZoom * 2
            adjustZoom()
        }

    }
    
    func plusButtonPressed(sender:UIButton)
    {
        
        if myZoom > 0.0031
        {
            
            myZoom = myZoom / 2
            adjustZoom()
        }

    }
    
    func mapSegmentPressed(sender:  UISegmentedControl)
    {
        switch (sender.selectedSegmentIndex)
            {
        case 0:
            self.mapView.mapType = .Standard
        case 1:
            self.mapView.mapType = .Hybrid
        case 2:
            self.mapView.mapType = .Satellite
        default:
            self.mapView.mapType = .Standard
        }
    }

}


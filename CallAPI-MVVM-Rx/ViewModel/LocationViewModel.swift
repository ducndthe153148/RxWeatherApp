//
//  LocationViewModel.swift
//  CallAPI-MVVM-Rx
//
//  Created by Nguyễn Đình Trung Đức on 30/12/2021.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation
import UIKit

class LocationViewModel: NSObject, CLLocationManagerDelegate {
        
    var viewWillApper: BehaviorRelay<Void> = .init(value: ())
    var disposedBag = DisposeBag()
    var sendLocation: BehaviorRelay<CLPlacemark> = .init(value: CLPlacemark())
    
    var currentLocation: CLLocation?
    static let shared: LocationViewModel = LocationViewModel()
    let locationManager = CLLocationManager()
    
    override init(){
        super.init()
        
        self.viewWillApper.subscribe({ [weak self] event in
            guard let self = self else { return }
            switch event {
            case .next:
                self.checkLocation()
            default:
                return
            }
        }).disposed(by: disposedBag)
        
    }
    
    func checkLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        guard let currentLocation = currentLocation else { return }
        let long = currentLocation.coordinate.longitude
        print("day la dong long thu 44: \(long)")
        self.changeLocation()
    }
    
    func changeLocation() {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation!) { [weak self] (placemarks, error) in
            guard let self = self else { return }
                if (error != nil){
                    print("error in reverseGeocode")
                }
                let placemark = placemarks! as [CLPlacemark]
                if placemark.count>0{
                    let placemark = placemarks![0]
                    print(placemark.locality!)
                    print(placemark.administrativeArea!)
                    print(placemark.country!)
                    self.sendLocation.accept(placemark)
                }
            }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil  {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            
            print("Start request weather")
            
            guard let currentLocation = currentLocation else { return }
            
            let long = currentLocation.coordinate.longitude
            let lat = currentLocation.coordinate.latitude
            print("Long is: \(long) and lat is: \(lat)")
        }
    }
}

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
    var place: CLPlacemark?
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
        self.changeLocation { [weak self] a in
            guard let self = self else { return }
            DispatchQueue.main.async {
                //self.sendLocation.accept(a)
            }
        }
    }
    
    func changeLocation(completion: @escaping (CLPlacemark)->()) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation!) { [weak self] (placemarks, error) in
            guard let self = self else { return }
                if (error != nil){
                    print("error in reverseGeocode")
                }
                let placemark = placemarks! as [CLPlacemark]
                if placemark.count>0{
                    let a = placemarks
                    var placemark1 = a![0]
                    var placemark2 = CLPlacemark(placemark: placemark1)
                    self.place = CLPlacemark(placemark: placemark1)
                    print(placemark1.locality!)
                    print(placemark1.administrativeArea!)
                    print(placemark1.country!)
                    self.sendLocation.accept(CLPlacemark(placemark: placemark1))
                    //completion(self.place!)
                   
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

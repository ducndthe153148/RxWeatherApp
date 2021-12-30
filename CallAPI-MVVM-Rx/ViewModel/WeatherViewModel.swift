//
//  CountryViewModel.swift
//  CallAPI-MVVM-Rx
//
//  Created by Nguyễn Đình Trung Đức on 27/12/2021.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

class WeatherViewModel {
    var apiCalling = APICalling()
    
    //MARK: - Property
    weak var vc: UIViewController!
//    var listCountry: PublishRelay<[CountryListModel]> = .init()
    var listWeather: PublishRelay<[HourlyWeather]> = .init()
    var modelSelect: PublishRelay<HourlyWeather> = .init()
    var receiveModelHourly: BehaviorRelay<HourlyWeather> = .init(value: HourlyWeather())
    
    var models = [HourlyWeather]()
    
    var viewWillApper: BehaviorRelay<Void> = .init(value: ())
    var disposedBag = DisposeBag()
    
    var currentLocation: CLLocation?
    var locationManager = CLLocationManager()
    
    init(vc: UIViewController) {
        self.viewWillApper.subscribe({ [weak self] event in
            guard let self = self else { return }
            switch event {
            case .next:
                self.ViewModel()
            default:
                return
            }
        }).disposed(by: disposedBag)
//        self.clickCell()
        
        modelSelect.subscribe(onNext: { model in
            let storyboard = UIStoryboard(name: "HourlyDetailViewController", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "HourlyDetailViewController") as! HourlyDetailViewController
            
//            self?.sendHourlyWeather.accept(indexPath.row)
            controller.viewModel.receiveModelHourly.accept(model)
            vc.navigationController?.pushViewController(controller, animated: true)
            
        }).disposed(by: disposedBag)
        self.vc = vc
    }
    
    func ViewModel() {
        let request = APIRequest()
        self.apiCalling.send(apiRequest: request, type: WeatherReponse.self).subscribe(onNext: { [weak self] list in
            guard let self = self else { return }
            let entries = list.hourly
            self.models.append(contentsOf: entries!)
            
            self.listWeather.accept(self.models)
            
        }).disposed(by: disposedBag)
    }
    
    func setupLocation() {
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
    }
    
//    func ViewModel() {
//        let request = APIRequest()
//        self.apiCalling.send(apiRequest: request, type: CountryModel.self).subscribe(onNext: { [weak self] list in
//            guard let self = self else { return }
//            self.listCountry.accept(list.result ?? [])
//        }).disposed(by: disposedBag)
//    }
    
//    func clickCell(){
//        self.sendHourlyWeather.subscribe(onNext: { [weak self] number in
//            // print("cell thu may: \(self!.models[number])")
//            print("Chay vao day la cell so: \(number)")
//            self!.receiveModelHourly.accept(self!.models[number])
//        })
//    }
    
}

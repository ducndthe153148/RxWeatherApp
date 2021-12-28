//
//  CountryViewModel.swift
//  CallAPI-MVVM-Rx
//
//  Created by Nguyễn Đình Trung Đức on 27/12/2021.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherViewModel {
    var apiCalling = APICalling()
    
    //MARK: - Property 
    var listCountry: PublishRelay<[CountryListModel]> = .init()
    var listWeather: PublishRelay<[HourlyWeather]> = .init()
    var sendHourlyWeather: PublishRelay<Int> = .init()
    var receiveModelHourly: PublishRelay<HourlyWeather> = .init()
    
    var models = [HourlyWeather]()
    
    var viewWillApper: PublishRelay<Void> = .init()
    var disposedBag = DisposeBag()
    
    init() {
        self.viewWillApper.subscribe({ [weak self] event in
            guard let self = self else { return }
            switch event {
            case .next:
                self.ViewModel()
            default:
                return
            }
        }).disposed(by: disposedBag)
        self.clickCell()
    }
    
//    func ViewModel() {
//        let request = APIRequest()
//        self.apiCalling.send(apiRequest: request, type: CountryModel.self).subscribe(onNext: { [weak self] list in
//            guard let self = self else { return }
//            self.listCountry.accept(list.result ?? [])
//        }).disposed(by: disposedBag)
//    }
    
    func clickCell(){
        self.sendHourlyWeather.subscribe(onNext: { [weak self] number in
            // print("cell thu may: \(self!.models[number])")
            print("Chay vao day")
            self!.receiveModelHourly.accept(self!.models[number])
        })
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
    
}

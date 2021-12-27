//
//  CountryViewModel.swift
//  CallAPI-MVVM-Rx
//
//  Created by Nguyễn Đình Trung Đức on 27/12/2021.
//

import Foundation
import RxSwift
import RxCocoa

class CountryViewModel {
    var apiCalling = APICalling()
    var listCountry: PublishRelay<[CountryListModel]> = .init()
    var listWeather: PublishRelay<WeatherReponse> = .init()
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
    }
    
    func ViewModel() {
        let request = APIRequest()
        self.apiCalling.send(apiRequest: request, type: CountryModel.self).subscribe(onNext: { [weak self] list in
            guard let self = self else { return }
            self.listCountry.accept(list.result ?? [])
        }).disposed(by: disposedBag)
        
    }
    
}

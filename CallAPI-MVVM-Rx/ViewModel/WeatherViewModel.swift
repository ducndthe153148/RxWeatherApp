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
import RxDataSources
import NotificationCenter

// MARK: - Test:
struct TableViewItem {
    let title: HourlyWeather
    
    init(title: HourlyWeather) {
        self.title = title
    }
}

struct TableViewSection {
    let items: [TableViewItem]
    let header: String
    
    init(items: [TableViewItem], header: String) {
        self.items = items
        self.header = header
    }
}

extension TableViewSection: SectionModelType {
    typealias Item = TableViewItem
    
    init(original: Self, items: [Self.Item]) {
        self = original
    }
}

class WeatherViewModel {
    var apiCalling = APICalling()
    
    //MARK: - Property
    weak var vc: UIViewController!
//    var listCountry: PublishRelay<[CountryListModel]> = .init()
    var listWeather: PublishRelay<[HourlyWeather]> = .init()
    var listWeatherTest: BehaviorRelay<[SectionModel<String, HourlyWeather>]> = .init(value: [])
    
    var modelSelect: PublishRelay<HourlyWeather> = .init()
    var receiveModelHourly: BehaviorRelay<HourlyWeather> = .init(value: HourlyWeather())
    
    var models = [HourlyWeather]()
    
    var viewWillApper: PublishRelay<Void> = .init()
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
            print("chet roi bi lap roi")
            guard let self = self else { return }
            let entries = list.hourly
            self.models.append(contentsOf: entries!)
            
            self.listWeather.accept(self.models)
            self.listWeatherTest.accept(
                [SectionModel(model: "Test", items: self.models)]
            )
            
        }).disposed(by: disposedBag)
    }
    
    func sendNoti(){
        // Step 1: Ask for permission
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            // Step 2: create the notification content
            let content = UNMutableNotificationContent()
            content.title = "Hey i'm Trung Duc handsome"
            content.body = "Look at me"
            
            // Step 3: Create the notification trigger
            let date = Date().addingTimeInterval(5)
            let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger (dateMatching: dateComponent, repeats: false)
            
            // Step 4: Create the request
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            
            // Step 5: Register the request
            center.add(request) { error in
                // check the error parameter and handle error
                
            }
        }
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

//
//  HourlyDetailViewController.swift
//  CallAPI-MVVM-Rx
//
//  Created by Nguyễn Đình Trung Đức on 28/12/2021.
//

import UIKit
import RxSwift
import RxCocoa

class HourlyDetailViewController: UIViewController {

    @IBOutlet weak var labelTest: UILabel!
    @IBOutlet weak var weatherDescrip: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempFeel: UILabel!
    
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var clouds: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var uvi: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var visibility: UILabel!
    @IBOutlet weak var pop: UILabel!
    @IBOutlet weak var rainRate: UILabel!
    
    //MARK: - Property
    
//    var receiveModelHourly: PublishRelay<HourlyWeather> = .init()

    var disposedBag = DisposeBag()
    lazy var viewModel = WeatherViewModel(vc: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(doThis), name: NSNotification.Name("Test"), object: nil)
        print("Go here")
    }
    
    @objc func doThis () {
        let alert = UIAlertController(title: "YOUR_TITLE", message: "YOUR_MESSAGE", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            // Handle your ok action
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            // Handle your cancel action
        }
        alert.addAction(cancelAction)
        print("Go to do this")
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.receiveModelHourly.bind(to: self.viewModel.receiveModelHourly).disposed(by: disposedBag)
//
        viewModel.receiveModelHourly.subscribe(onNext: { [weak self] model in
            guard let self = self else { return }
            if model.weather != nil {
                self.labelTest.text = "Tokyo, Japan"
                self.weatherDescrip.text = "\(model.weather?[0].description! ?? "")"
                self.tempLabel.text = "\(Int(Float(model.temp ?? 0) - 272.15))°"
                self.tempFeel.text = "\(Int(Double(model.feels_like ?? 0) - 272.15))°"
                self.pressure.text = "Pressure: \((model.pressure)!)"
                self.clouds.text = "Cloudiness: \((model.clouds)!)%"
                self.humidity.text = "Humidity: \((model.humidity)!)%"
                self.uvi.text = "Current UV: 0"
                self.windSpeed.text = "Wind speed: \((model.wind_speed)!)"
                self.visibility.text = "Visibility: \((model.visibility)!) m"
                self.pop.text = "Precipitation: \((model.pop)!)"
                self.rainRate.text = "Rain rate: 20%"
            }
            
        }).disposed(by: disposedBag)
                
    }
    
    
}

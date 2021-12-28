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
        
//        self.receiveModelHourly.bind(to: self.viewModel.receiveModelHourly).disposed(by: disposedBag)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.receiveModelHourly.bind(to: self.viewModel.receiveModelHourly).disposed(by: disposedBag)
//
        viewModel.receiveModelHourly.subscribe(onNext: { model in
            if model.weather != nil {
                print("Model del \(model)")
                print("ABCD Model")
            }
            
        }).disposed(by: disposedBag)
        
//        labelTest.text = "Trung Duc"
        
    }
    
    
}

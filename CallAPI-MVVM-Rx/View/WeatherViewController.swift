//
//  ViewController.swift
//  CallAPI-MVVM-Rx
//
//  Created by Nguyễn Đình Trung Đức on 27/12/2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import CoreLocation
import UserNotifications

class WeatherViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    
    var viewWillAppear: BehaviorRelay<Void> = .init(value: ())
    
    var sendHourlyWeather: PublishRelay<Int> = .init()
    
    var disposedBag = DisposeBag()
    
    lazy var viewModel = WeatherViewModel(vc: self)
    var locationModel = LocationViewModel()
    var modelsTest = [HourlyWeather]()
    
    // Data source
    let dataSource1 = RxTableViewSectionedReloadDataSource<SectionModel<String, HourlyWeather>>(
        configureCell: { (dataSource, tabbleView, indexPath, item) in

            print("Do anh biet indexpath la bnhieu: \(indexPath)")
            let cell = tabbleView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell

            let date = NSDate(timeIntervalSince1970: item.dt!)
            cell.labelTest.text = WeatherViewController.changeDTDate(dtTime: date as Date)
            cell.feelTemp.text = "\(Int(Double(item.feels_like!) - 272.15))°"
            cell.realTemp.text = "\(Int(Double(item.temp!) - 272.15))°"
            // Back ground color  cell
            cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
            
            let icon = item.weather?[0].icon
            cell.imageIcon.image = UIImage(named: icon!)
            
            return cell
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(WeatherTableViewCell.nib().self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
//        tableView.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        tableView.register(UINib(nibName: "CustomerHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomerHeaderView")

        
        headerView.frame.size.width = view.frame.size.width
        headerView.frame.size.height = view.frame.size.height / 4
        
        view.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)

        // bind data
        self.viewModel.listWeatherTest.asObservable().bind(to: self.tableView.rx.items(dataSource: dataSource1)).disposed(by: disposedBag)
        self.viewWillAppear.bind(to: self.viewModel.viewWillApper).disposed(by: disposedBag)
        // MARK: - dang co bug o day
//        self.viewWillAppear.bind(to: self.locationModel.viewWillApper).disposed(by: disposedBag)
        
//        Set delegate
        self.tableView.rx.setDelegate(self).disposed(by: disposedBag)
        
//        event tap on each cell
        tableView.rx.modelSelected(HourlyWeather.self).subscribe(onNext: { [weak self] model in
            NotificationCenter.default.post(name: Notification.Name("Test"), object: nil)
            guard let self = self else { return }
            print("Danh van di: \(model)")
            self.viewModel.sendNoti()
            
            self.viewModel.modelSelect.accept(model)
        }).disposed(by: disposedBag)
        
//        // MARK: - Send Local Notification
//        // Step 1: Ask for permission
//        let center = UNUserNotificationCenter.current()
//        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
//            // Step 2: create the notification content
//            let content = UNMutableNotificationContent()
//            content.title = "Hey i'm Trung Duc handsome"
//            content.body = "Look at me"
//
//            // Step 3: Create the notification trigger
//            let date = Date().addingTimeInterval(5)
//            let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//            let trigger = UNCalendarNotificationTrigger (dateMatching: dateComponent, repeats: false)
//
//            // Step 4: Create the request
//            let uuidString = UUID().uuidString
//            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
//
//            // Step 5: Register the request
//            center.add(request) { error in
//                // check the error parameter and handle error
//
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.headerView.frame.size = CGSize(width: tableView.frame.width, height: tableView.frame.width)
        print("Accept 1 view View Will appear")
        viewWillAppear.accept(())
    }
    
}

extension WeatherViewController {
    
    static func changeDTDate (dtTime: Date?) -> String {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEEE hh:mm"
        let dateString = dayTimePeriodFormatter.string(from: dtTime! as Date)
        return dateString
    }
    
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/6
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomerHeaderView") as! CustomerHeaderView
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
}


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
//            if indexPath.section == 0 {
//                let cell = tabbleView.dequeueReusableCell(withIdentifier: "HourlyTableViewCell", for: indexPath) as! HourlyTableViewCell
//                return cell
//            }
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
        
        
//        self.viewModel.listWeather.bind(to: tableView.rx.items(cellIdentifier: "WeatherTableViewCell", cellType: WeatherTableViewCell.self)) { (row, model, cell) in
//            let date = NSDate(timeIntervalSince1970: model.dt!)
//            cell.labelTest.text = WeatherViewController.changeDTDate(dtTime: date as Date)
//            cell.feelTemp.text = "\(Int(Double(model.feels_like!) - 272.15))°"
//            cell.realTemp.text = "\(Int(Double(model.temp!) - 272.15))°"
//            // Back ground color  cell
//            cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
//
//            let icon = model.weather?[0].icon
//            cell.imageIcon.image = UIImage(named: icon!)
//
//        }.disposed(by: disposedBag)
        
        // bind data
        
        self.viewModel.listWeatherTest.asObservable().bind(to: self.tableView.rx.items(dataSource: dataSource1)).disposed(by: disposedBag)
        
        self.viewWillAppear.bind(to: self.viewModel.viewWillApper).disposed(by: disposedBag)
        
        // dang co bug o day
//        self.viewWillAppear.bind(to: self.locationModel.viewWillApper).disposed(by: disposedBag)
        
        self.tableView.rx.setDelegate(self).disposed(by: disposedBag)
        
//        event tap on each cell
        tableView.rx.modelSelected(HourlyWeather.self).subscribe(onNext: { [weak self] model in
            guard let self = self else { return }
            print("Danh van di: \(model)")
            self.viewModel.modelSelect.accept(model)
        }).disposed(by: disposedBag)
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
    
    //    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    //        view.tintColor = UIColor.purple
    //    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomerHeaderView") as! CustomerHeaderView
        headerView.collectionView.register(WeatherCollectionViewCell.nib().self, forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
        
        headerView.collectionView.delegate = self
        headerView.collectionView.dataSource = self
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as! WeatherCollectionViewCell
//        cell.config()
        
        self.viewModel.listWeather.subscribe(onNext: { [weak self] models in
//            print(models)
            cell.configure(with: models[indexPath.row])
        })
        
        return cell
    }
    
}

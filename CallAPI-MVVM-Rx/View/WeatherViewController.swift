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
    
    
    var viewWillAppear: PublishRelay<Void> = .init()
    
    var sendHourlyWeather: PublishRelay<Int> = .init()
    
    var disposedBag = DisposeBag()
    lazy var viewModel = WeatherViewModel(vc: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(WeatherTableViewCell.nib().self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        headerView.frame.size.width = view.frame.size.width
        headerView.frame.size.height = view.frame.size.height / 4
        
        view.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        
        self.viewModel.listWeather.bind(to: tableView.rx.items(cellIdentifier: "WeatherTableViewCell", cellType: WeatherTableViewCell.self)) { (row, model, cell) in
            let date = NSDate(timeIntervalSince1970: model.dt!)
            cell.labelTest.text = self.changeDTDate(dtTime: date as Date)
            cell.feelTemp.text = "\(Int(Double(model.feels_like!) - 272.15))°"
            cell.realTemp.text = "\(Int(Double(model.temp!) - 272.15))°"
            // Back ground color  cell
            cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
            
            let icon = model.weather?[0].icon
            cell.imageIcon.image = UIImage(named: icon!)
            
        }.disposed(by: disposedBag)
        
        self.viewWillAppear.bind(to: self.viewModel.viewWillApper).disposed(by: disposedBag)
//        self.sendHourlyWeather.bind(to: self.viewModel.sendHourlyWeather).disposed(by: disposedBag)
        
        self.tableView.rx.setDelegate(self).disposed(by: disposedBag)
        
        tableView.rx.modelSelected(HourlyWeather.self).subscribe(onNext: { [weak self] model in
            guard let self = self else { return }
             self.viewModel.modelSelect.accept(model)
        }).disposed(by: disposedBag)
        
//        tableView.rx
//            .itemSelected
//            .subscribe(onNext: { [weak self] indexPath in
//                let storyboard = UIStoryboard(name: "HourlyDetailViewController", bundle: nil)
//                let controller = storyboard.instantiateViewController(withIdentifier: "HourlyDetailViewController") as! HourlyDetailViewController
//
//                self?.sendHourlyWeather.accept(indexPath.row)
//
//                self?.navigationController?.pushViewController(controller, animated: true)
//            })
        
//        let dataSouce = RxTableViewSectionedReloadDataSource<SectionModelType> (configureCell: {(_, tv, indexPath, element) in
//
//        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.headerView.frame.size = CGSize(width: tableView.frame.width, height: tableView.frame.width)
        viewWillAppear.accept(())
    }
    
    func createTableHeader() -> UIView{
        let headerVIew = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        headerVIew.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        
        return headerVIew
    }
}

extension WeatherViewController {
    
    func changeDTDate (dtTime: Date?) -> String {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEEE hh:mm"
        let dateString = dayTimePeriodFormatter.string(from: dtTime! as Date)
        return dateString
    }
    
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

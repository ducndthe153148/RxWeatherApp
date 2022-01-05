//
//  CustomerHeaderView.swift
//  CallAPI-MVVM-Rx
//
//  Created by Nguyễn Đình Trung Đức on 05/01/2022.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class CustomerHeaderView: UITableViewHeaderFooterView {
    
    lazy var viewModel = WeatherViewModel(vc: UIViewController())
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("Tup leu ly tuong")
        collectionView.register(WeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
        
        // Bind data
        self.viewModel.listWeather.bind(to: collectionView.rx.items(cellIdentifier: WeatherCollectionViewCell.identifier, cellType: WeatherCollectionViewCell.self)) { (row, model, cell) in
            
            cell.tempLabel.text = "\(Int((model.temp!) - 272.15))°"
            cell.imageIcon.contentMode = .scaleAspectFit
            cell.imageIcon.image = UIImage(named: model.weather![0].icon!)
            
            let date = NSDate(timeIntervalSince1970: model.dt!)
            // get hour now (so sanh voi time chinh)
            let dateNow = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: dateNow)
            
            cell.timeNow.text = "\(self.getHourForDate(date as Date))"
            
        }.disposed(by: disposeBag)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        print("Ga la ga dang gay 123 ")

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("Ga la ga dang gay 456")

    }
    
}

extension CustomerHeaderView {
    func getHourForDate(_ date : Date?) -> String {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh"
        let dateString = dayTimePeriodFormatter.string(from: date! as Date)
        return dateString
    }
}

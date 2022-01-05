//
//  WeatherCollectionViewCell.swift
//  CallAPI-MVVM-Rx
//
//  Created by Nguyễn Đình Trung Đức on 04/01/2022.
//

import UIKit
import RxCocoa
import RxSwift

class WeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeNow: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    var viewWillAppear: BehaviorRelay<Void> = .init(value: ())
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static let identifier = "WeatherCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
    }
    
    func config(){
        
        timeNow.text = "ABC"
    }
    
    func configure(with model: HourlyWeather){
        self.tempLabel.text = "\(Int((model.temp!) - 272.15))°"
        self.imageIcon.contentMode = .scaleAspectFit
        self.imageIcon.image = UIImage(named: model.weather![0].icon!)
        
        let date = NSDate(timeIntervalSince1970: model.dt!)
        // get hour now (so sanh voi time chinh)
        let dateNow = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: dateNow)
        
        self.timeNow.text = "\(getHourForDate(date as Date))"
    }
    
    func getHourForDate(_ date : Date?) -> String {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh"
        let dateString = dayTimePeriodFormatter.string(from: date! as Date)
        return dateString
    }
}

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
    

}

//
//  CountryTableViewCell.swift
//  CallAPI-MVVM-Rx
//
//  Created by Nguyễn Đình Trung Đức on 27/12/2021.
//

import UIKit
import RxCocoa
import RxSwift

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTest: UILabel!
    @IBOutlet weak var realTemp: UILabel!
    @IBOutlet weak var feelTemp: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "CountryTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CountryTableViewCell", bundle: nil)
    }
    
    private let apiCalling = APICalling()
    private let disposeBag = DisposeBag()
    
    func configure(){
        
    }

    
}

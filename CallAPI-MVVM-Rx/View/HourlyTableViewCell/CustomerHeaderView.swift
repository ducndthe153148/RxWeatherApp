//
//  CustomerHeaderView.swift
//  CallAPI-MVVM-Rx
//
//  Created by Nguyễn Đình Trung Đức on 05/01/2022.
//

import UIKit

class CustomerHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        print("Tup leu ly tuong")
        // collectionView.register(WeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
        
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        print("Ga la ga dang gay 123 ")
//        collectionView.register(WeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
//        collectionView.delegate = self
//        collectionView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("Ga la ga dang gay 456")
        collectionView.register(WeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension CustomerHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {
    // Khong chay vao day
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as! WeatherCollectionViewCell
        cell.timeNow.text = "16"
        return cell
    }
}

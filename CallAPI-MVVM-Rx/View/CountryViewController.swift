//
//  ViewController.swift
//  CallAPI-MVVM-Rx
//
//  Created by Nguyễn Đình Trung Đức on 27/12/2021.
//

import UIKit
import RxSwift
import RxCocoa

class CountryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewWillAppear: PublishRelay<Void> = .init()
    var disposedBag = DisposeBag()
    let viewModel = CountryViewModel()
    let apiCalling = APICalling()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(CountryTableViewCell.nib().self, forCellReuseIdentifier: CountryTableViewCell.identifier)
        
//        self.viewModel.listCountry.bind(to: tableView.rx.items(cellIdentifier: "CountryTableViewCell", cellType: CountryTableViewCell.self)) { ( row, model, cell) in
////            cell.textLabel?.text = model.name
//            cell.labelTest.text = model.name
//            cell.realTemp.text = model.code
//
//        }.disposed(by: disposedBag)
        
        self.viewModel.listWeather.bind(to: tableView.rx.items(cellIdentifier: "CountryTableViewCell", cellType: CountryTableViewCell.self)) { (row, model, cell) in
            cell.labelTest.text = "model123"
            cell.feelTemp.text = "\(Int(Double(model.feels_like!) - 272.15))°"
            cell.realTemp.text = "\(Int(Double(model.temp!) - 272.15))°"
            
        }.disposed(by: disposedBag)
        self.viewWillAppear.bind(to: self.viewModel.viewWillApper).disposed(by: disposedBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewWillAppear.accept(())
    }
    
}

//extension CountryViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 90
//    }
//}

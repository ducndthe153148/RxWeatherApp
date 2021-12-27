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
        
        self.viewModel.obser.bind(to: tableView.rx.items(cellIdentifier: "CountryTableViewCell")) { ( row, model, cell) in
            cell.textLabel?.text = model.name
        }.disposed(by: disposedBag)
        
        self.viewWillAppear.bind(to: self.viewModel.viewWillApper).disposed(by: disposedBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewWillAppear.accept(())
    }
    
}

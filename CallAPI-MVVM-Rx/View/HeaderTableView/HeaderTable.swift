//
//  HeaderTable.swift
//  CallAPI-MVVM-Rx
//
//  Created by Nguyễn Đình Trung Đức on 29/12/2021.
//

import UIKit

class HeaderTable: UIView {
    
    @IBOutlet var contentView: HeaderTable!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var type: UILabel!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    private func setUpView(){
        Bundle.main.loadNibNamed("HeaderTable", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
    }
    
    
}

//
//  SectionOfCustomData.swift
//  CallAPI-MVVM-Rx
//
//  Created by Nguyễn Đình Trung Đức on 29/12/2021.
//

import Foundation
import RxDataSources
import RxSwift

let items = Observable.just([
    SectionModel(model: "ABC", items: [
        
    ])
])
//struct CustomData {
//  var anInt: Int
//  var aString: String
//  var aCGPoint: CGPoint
//}
//
//enum SectionOfCustomData: SectionModelType {
//
//  typealias Item = Row
//
//  case customDataSection(header: String, items: [Row])
//  case stringSection(header: String, items: [Row])
//
//  enum Row {
//    case customData(customData: CustomData) // wrapping CustomData to Row type
//    case string(string: String)             // wrapping String to Row type
//  }
//
//  // followings are not directly related to this topic, but represents how to conform to SectionModelType
//  var items: [Row] {
//    switch self {
//    case .customDataSection(_, let items):
//      return items
//
//    case .stringSection(_, let items):
//      return items
//    }
//  }
//
//  public init(original: SectionOfCustomData, items: [Row]) {
//    switch self {
//    case .customDataSection(let header, _):
//      self = .customDataSection(header: header, items: items)
//
//    case .stringSection(let header, _):
//      self = .stringSection(header: header, items: items)
//    }
//  }
//}

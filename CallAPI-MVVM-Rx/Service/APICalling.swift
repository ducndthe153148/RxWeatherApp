//
//  APICalling.swift
//  CallAPI-MVVM-Rx
//
//  Created by Nguyễn Đình Trung Đức on 27/12/2021.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

public enum RequestType: String {
    case GET, POST, PUT, DELETE
}

class APIRequest {
//    change url to weather api
//    let baseURL = URL(string: "https://api.printful.com/countries")!
    
    let baseURL = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=35.7020691&lon=139.7753269&appid=78ed6b8b11e08ae58625e4a726e6d625")!
    var method = RequestType.GET
    var parameters = [String: String]()
    
    func request (with baseURL: URL) -> URLRequest {
        var request = URLRequest(url: baseURL)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}


class APICalling {
    // create a method for calling api which is return a Observable
    func send<T: Codable>(apiRequest: APIRequest, type: T.Type) -> Observable<T> {
        print("vvvvv")
        // Using alamofire
        return Observable<T>.create { observer in
            let task = AF.request(apiRequest.baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil)
                .response{ (responseData) in
                    guard let data = responseData.data else { return }
                    do {
                        print("DDDDDD")
                        let model = try JSONDecoder().decode(T.self, from: data)
                        observer.onNext(model)
                    } catch {
                        observer.onError(error)
                    }
                    observer.onCompleted()
                }

                // Using URLSession
//            let request = apiRequest.request(with: apiRequest.baseURL)
//            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//                do {
//                    print("DDDDDD")
//                    let model = try JSONDecoder().decode(T.self, from: data ?? Data())
//                    observer.onNext(model)
//                } catch let error {
//                    print("ERRORRRRR")
//                    observer.onError(error)
//                }
//                observer.onCompleted()
//            }
//            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}


//singleton:
//
//Bản gốc:
//Sơ yếu lí lịch
//Giấy khám sức khỏe
//Ảnh 3*4 (2)
//
//Công chứng:
//Sổ hộ khẩu
//CMND
//Giấy khai sinh
//Bằng tốt nghiệp

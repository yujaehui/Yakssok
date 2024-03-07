//
//  APIService.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/7/24.
//

import Foundation
import Alamofire

class APIService {
    static let shared = APIService()
    private init() {}
    
    func fetchSupplementAPI(completionHandler: @escaping ([Row]) -> Void) {
        let url = "http://openapi.foodsafetykorea.go.kr/api/\(APIKey.keyId)/I0030/json/1/1000"
        AF.request(url).responseDecodable(of: Supplement.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success.i0030.row)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

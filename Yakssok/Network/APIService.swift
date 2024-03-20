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
    
    func fetchSupplementAPI(api: SupplementAPI, completionHandler: @escaping (I0030) -> Void) {
        AF.request(api.endpoint).responseDecodable(of: Supplement.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success.i0030)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

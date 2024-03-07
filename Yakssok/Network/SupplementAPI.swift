//
//  SupplementAPI.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/7/24.
//

import Foundation

enum SupplementAPI {
    case supplement(startIdx: String, endIdx: String, PRDLST_NM: String)
    
    var baseURL: String {
        return "http://openapi.foodsafetykorea.go.kr/api/\(APIKey.keyId)/I0030/json"
    }
    
    var endpoint: URL {
        switch self {
        case .supplement(let startIdx, let endIdx, let PRDLST_NM):
            return URL(string: baseURL + "/\(startIdx)/\(endIdx)/PRDLST_NM=\(PRDLST_NM)")!
        }
    }
}

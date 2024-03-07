//
//  Supplement.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/7/24.
//

import Foundation

// MARK: - Supplement
struct Supplement: Codable {
    let i0030: I0030

    enum CodingKeys: String, CodingKey {
        case i0030 = "I0030"
    }
}

// MARK: - I0030
struct I0030: Codable {
    let totalCount: String
    let row: [Row]
    let result: Result

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case row
        case result = "RESULT"
    }
}

// MARK: - Row
struct Row: Codable {
    let prdtShapCDNm: String
    let lastUpdtDtm : String
    let prdlstNm: String
    let bsshNm: String
    let pogDaycnt: String
    let ntkMthd: String

    enum CodingKeys: String, CodingKey {
        case prdtShapCDNm = "PRDT_SHAP_CD_NM"
        case lastUpdtDtm = "LAST_UPDT_DTM"
        case prdlstNm = "PRDLST_NM"
        case bsshNm = "BSSH_NM"
        case pogDaycnt = "POG_DAYCNT"
        case ntkMthd = "NTK_MTHD"
    }
}

// MARK: - Result
struct Result: Codable {
    let msg, code: String

    enum CodingKeys: String, CodingKey {
        case msg = "MSG"
        case code = "CODE"
    }
}


//
//  SpindlJSONDecoder.swift
//
//
//  Created by מאיר רדנוביץ׳ on 19/11/2023.
//

import Foundation

class SpindlJSONDecoder : JSONDecoder {
    override init() {
        super.init()
        self.dateDecodingStrategy = .millisecondsSince1970
    }
}

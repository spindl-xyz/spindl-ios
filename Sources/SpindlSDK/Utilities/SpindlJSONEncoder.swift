//
//  SpindlJSONEncoder.swift
//
//
//  Created by מאיר רדנוביץ׳ on 19/11/2023.
//

import Foundation

class SpindlJSONEncoder : JSONEncoder {
    override init() {
        super.init()
        self.dateEncodingStrategy = .secondsSince1970
        #if DEBUG
        self.outputFormatting = [.prettyPrinted, .sortedKeys]
        #endif
    }
}

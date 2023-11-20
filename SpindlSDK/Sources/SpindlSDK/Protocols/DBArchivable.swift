//
//  DBArchivable.swift
//
//
//  Created by מאיר רדנוביץ׳ on 20/11/2023.
//

import Foundation
import Blackbird


protocol DBArchivable {
    associatedtype RecordType : BlackbirdModel
    
    func record() throws -> RecordType
    init(record: RecordType) throws
}


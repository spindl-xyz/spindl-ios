//
//  Uploader.swift
//
//
//  Created by מאיר רדנוביץ׳ on 20/11/2023.
//

import Foundation
import Blackbird

actor Uploader {
    private let db: Blackbird.Database
    private let taskmaster = RepeatingTaskmaster(timeInterval: NetworkingConstants.uploadInterval)
    
    init(db: Blackbird.Database) {
        self.db = db
        
        Task {
            await taskmaster.setEventHandler(upload)
        }
    }
    
    private func upload() async {
        
    }
}

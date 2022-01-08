//
//  NFLState.swift
//  Sleeper League Helper
//
//  Created by Ethan Park on 12/8/21.
// edpark@usc.edu
//

import UIKit

class NFLState: Decodable {
    private var week: Int

//    override init() {
//        week = 0
//    }
    
    public func getWeek() -> Int {
        return week
    }
}

//
//  Settings.swift
//  Sleeper League Helper
//
//  Created by Ethan Park on 12/8/21.
// edpark@usc.edu
//

import UIKit

class Settings: Decodable {
    private let wins: Int
    private let losses: Int
    
    public func getWins() -> Int {
        return wins
    }
    
    public func getLosses() -> Int {
        return losses
    }
}

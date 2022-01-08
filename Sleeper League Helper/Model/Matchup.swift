//
//  Matchup.swift
//  Sleeper League Helper
//
//  Created by Ethan Park on 12/7/21.
// edpark@usc.edu
//

import UIKit

// terrible name, team would've been better
class Matchup: Codable {
    private let roster_id: Int
    private let matchup_id: Int
    private let points: Double
    
    public func getRosterID() -> Int {
        return roster_id
    }
    
    public func getMatchupID() -> Int {
        return matchup_id
    }
    
    public func getPoints() -> Double {
        return points
    }
}

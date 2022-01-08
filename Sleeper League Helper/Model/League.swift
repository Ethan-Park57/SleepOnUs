//
//  League.swift
//  Sleeper League Helper
//
//  Created by Ethan Park on 12/7/21.
// edpark@usc.edu
//

import UIKit

class League: Codable {
    private let previous_league_id: String?
    private let league_id: String
    private let name: String
    
    public func getPreviousID() -> String {
        return previous_league_id ?? ""
    }
    
    public func getID() -> String {
        return league_id
    }
    
    public func getName() -> String {
        return name
    }
}

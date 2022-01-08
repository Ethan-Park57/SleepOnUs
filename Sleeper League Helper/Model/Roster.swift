//
//  Roster.swift
//  Sleeper League Helper
//
//  Created by Ethan Park on 12/8/21.
// edpark@usc.edu
//

import UIKit

class Roster: Decodable {
    private var roster_id: Int
    private var owner_id: String
    private var settings: Settings
    
    public func getRosterID() -> Int {
        return roster_id
    }
    
    public func getOwnerID() -> String {
        return owner_id
    }
    
    public func getSettings() -> Settings {
        return settings
    }
}

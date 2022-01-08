//
//  LeagueUsersModel.swift
//  Sleeper League Helper
//
//  Created by Ethan Park on 12/7/21.
// edpark@usc.edu
//

import UIKit

// singleton model with various data about league and users which removes everytime user enters new leagueID
class LeagueUsersModel: LeagueUsersDataModel {
    static let shared = LeagueUsersModel()
    
    public var usersIDToUsers = [String : User]()
    
    public var leagueID = String()
    public var leagueNameToUsers = [String : [User]]()
    public var nflState: NFLState?
    public var rosterIDToUserID = [Int : String]() // necessary mapping
    
    public var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    public let leagueUsersModelPath: URL
    
    public init() {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        leagueUsersModelPath = documentDirectory.appendingPathComponent("leagueUsers.json")

        print(leagueUsersModelPath)
        if FileManager.default.fileExists(atPath: leagueUsersModelPath.path) {
            load()
        }
    }
    
    public func save() {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(leagueID)
        let plistString = String(data: data, encoding: .utf8)!
        try! plistString.write(to: leagueUsersModelPath, atomically: false, encoding: .utf8)
    }
    
    public func load() {
        let decoder = JSONDecoder()
        let data = try! Data(contentsOf: leagueUsersModelPath)
        leagueID = try! decoder.decode(String.self, from: data)
    }
    
//    public var usersDisplayToUsers = [String : User]()
    
//    override init() {
//        super.init()
//        
//        // what is the best way to make these into "new" data structures
//        leagueNameToUsers.removeAll()
//        usersIDToUsers.removeAll()
//    }
}

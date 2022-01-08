//
//  User.swift
//  Sleeper League Helper
//
//  Created by Ethan Park on 12/6/21.
// edpark@usc.edu
//

import UIKit

class User: Codable {
    private let user_id: String
    private var display_name: String
    
    private var roster_id: Int?
    private var wins: Int?
    private var losses: Int?
    private var avgScore: Double?
    private var highScore: Double?
    private var lowScore: Double?
    
    /* ------- GETTERS ------- */
    public func getUserID() -> String {
        return user_id
    }
    
    public func getDisplayName() -> String {
        return display_name
    }
    
    public func getRosterID() -> Int? {
        return roster_id
    }

    public func getWins() -> Int? {
        return wins
    }

    public func getLosses() -> Int? {
        return losses
    }

    public func getAvgScore() -> Double? {
        return avgScore
    }

    public func getHighScore() -> Double? {
        return highScore
    }

    public func getLowScore() -> Double? {
        return lowScore
    }

    /* ------- SETTERS ------- */
    public func setRosterID(to value: Int) {
        self.roster_id = value
    }
    
    public func setWins(to value: Int) {
        wins = value
    }
    
    public func setLosses(to value: Int) {
        losses = value
    }
    
    public func setAvgScore(to value: Double) {
        avgScore = value
    }
    
    public func setHighScore(to value: Double) {
        highScore = value
    }
    
    public func setLowScore(to value: Double) {
        lowScore = value
    }
    
    public func incrementWins() {
        if wins == nil {
            wins = 1
        } else {
            wins! += 1
        }
    }
    
    public func incrementLosses() {
        if losses == nil {
            losses = 1
        } else {
            losses! += 1
        }
    }
}

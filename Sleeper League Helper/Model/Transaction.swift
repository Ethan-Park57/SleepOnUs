//
//  Transaction.swift
//  Sleeper League Helper
//
//  Created by Ethan Park on 12/8/21.
// edpark@usc.edu
//

import UIKit

class Transaction: Codable {
    private let type: String
    private let roster_ids: [Int]
    private let status: String
    
    public func getType() -> String {
        return type
    }
    
    public func getRosterIDs() -> [Int] {
        return roster_ids
    }
    
    public func getStatus() -> String {
        return status
    }
}



/* ADD
 
 - Drops: DroppedPlayer (these are player IDs and only include on waivers or don’t include at all)
     - DroppedPlayer
         - PlayerID: Int (which is the team who dropped)
 - draft_picks [DraftPick]
     - DraftPick
         - Season
         - Round
         - owner_id
         - Previous owner_id
 - Adds: AddedPlayer
     - AddedPlayer
         - PlayerID: Int (team who added)
 
 */

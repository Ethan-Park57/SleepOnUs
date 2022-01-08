//
//  ViewController.swift
//  Sleeper League Helper
//
//  Created by Ethan Park on 12/6/21.
// edpark@usc.edu
//

import UIKit
import Firebase
import CodableFirebase

class LeagueIDViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var baseURL = "https://api.sleeper.app/v1"
    public static let usersCollection = Firestore.firestore().collection("users")
    public static let leaguesCollection = Firestore.firestore().collection("leagues")
    public static var leagueID = ""

    @IBOutlet weak var leagueIDTextField: UITextField!
    @IBOutlet weak var leagueIDLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var favTeamButton: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    
    
    @IBAction func favButtonTapped(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            logoImage.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        leagueIDLabel.text = NSLocalizedString("Enter your league ID", comment: "")
        submitButton.setTitle(NSLocalizedString("Submit", comment: ""), for: .normal)
    }
    
    // when submit tapped, fetch users in this league and add to db
    @IBAction func submitDidTapped(_ sender: UIButton) {
        if let temp = leagueIDTextField.text {
            if !temp.isEmpty  {
                LeagueIDViewController.leagueID = temp
                LeagueUsersModel.shared.leagueID = temp
                Task.init {
                    // get league data from API
                    let league = await fetchLeague(from: LeagueIDViewController.leagueID)
                    if league == nil { return }
                    
                    // add league to Firestore db using Codable
                    let docData = try! FirestoreEncoder().encode(league!)
                    LeagueIDViewController.leaguesCollection.document(league!.getID()).setData(docData, merge: true) { error in
                        if let error = error {
                            print("Error writing document: \(error)")
                        } else {
                            print("League document successfully written!")
                        }
                    }
                    
                    // get all users in league from API
                    let usersArray = await fetchUsers(from: LeagueIDViewController.leagueID)
                    if usersArray == nil { return }
                    
                    // use league and user data to create model of league and users
                    LeagueUsersModel.shared.leagueNameToUsers[league!.getName()] = usersArray
                    for u in usersArray! {
                        LeagueUsersModel.shared.usersIDToUsers[u.getUserID()] = u
                    }
                    
                    // get rosters
                    let rosters = await fetchRosters(from: LeagueIDViewController.leagueID)
                    if rosters == nil { return }
                    
                    // use rosters to add rosterID field to every user
                    for r in rosters! {
                        LeagueUsersModel.shared.usersIDToUsers[r.getOwnerID()]?.setRosterID(to: r.getRosterID())
                        LeagueUsersModel.shared.usersIDToUsers[r.getOwnerID()]?.setWins(to: r.getSettings().getWins())
                        LeagueUsersModel.shared.usersIDToUsers[r.getOwnerID()]?.setLosses(to: r.getSettings().getLosses())
                        LeagueUsersModel.shared.rosterIDToUserID[r.getRosterID()] = r.getOwnerID()
                    }
                    
                    addUsersToDB()
                    LeagueUsersModel.shared.save()
                }
            }
            else {
                print(LeagueUsersModel.shared.leagueID)
            }
        }
    }
    
    // call Sleeper API to fetch league information, return nil if something goes wrong
    private func fetchLeague(from leagueID: String) async -> League? {
        guard let url = URL(string: "\(baseURL)/league/\(leagueID)") else {
            return nil
        }
        
        do {
            let (json, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(League.self, from: json)
        } catch {
            return nil
        }
    }
    
    // call Sleeper API to fetch users, return nil if something goes wrong
    private func fetchUsers(from leagueID: String) async -> [User]? {
        guard let url = URL(string: "\(baseURL)/league/\(leagueID)/users") else {
            return nil
        }
        
        do {
            let (json, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([User].self, from: json)
        } catch {
            return nil
        }
    }
    
    // call Sleeper API to fetch users, return nil if something goes wrong
    private func fetchRosters(from leagueID: String) async -> [Roster]? {
        guard let url = URL(string: "https://api.sleeper.app/v1/league/\(leagueID)/rosters") else {
            return nil
        }
        
        do {
            let (json, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([Roster].self, from: json)
        } catch {
            return nil
        }
    }
    
    // add users to db using Codable
    private func addUsersToDB() {
        for u in LeagueUsersModel.shared.usersIDToUsers.values {
            let docData = try! FirestoreEncoder().encode(u)
            LeagueIDViewController.usersCollection.document(u.getUserID() + LeagueIDViewController.leagueID).setData(docData, merge: true) { error in
                if let error = error {
                    print("Error writing document: \(error)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
    }
}



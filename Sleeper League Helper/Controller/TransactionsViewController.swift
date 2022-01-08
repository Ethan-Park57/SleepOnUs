//
//  TransactionsViewController.swift
//  Sleeper League Helper
//
//  Created by Ethan Park on 12/8/21.
// edpark@usc.edu
//

import UIKit

class TransactionsViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadTransactionsButton: UIButton!
    @IBOutlet weak var weekTextField: UITextField!
    @IBOutlet weak var transactionsTabItem: UITabBarItem!

    private var transactions: [Transaction]?

    // set localization strings
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        weekTextField.placeholder = NSLocalizedString("Enter week", comment: "")
        loadTransactionsButton.setTitle(NSLocalizedString("Update", comment: ""), for: .normal)
    }
    
    // when tapped, get all transactions that were completed and load
    @IBAction func loadButtonDidTapped(_ sender: UIButton) {
        Task.init {
            let tempTransactions = await fetchTransactions(forWeek: Int(weekTextField.text ?? "0") ?? 0)
            transactions = tempTransactions?.filter({$0.getStatus() == "complete"})
            tableView.reloadData()
        }
    }
    
    // set number cells = number transactions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions?.count ?? 0
    }
    
    // populate cells with type of transaction and users involved in transaction
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        var text = ""
        
        if transactions![indexPath.row].getType() == "waiver" || transactions![indexPath.row].getType() == "free_agent" {
            text = "Waiver add by: " + (LeagueUsersModel.shared.usersIDToUsers[LeagueUsersModel.shared.rosterIDToUserID[transactions![indexPath.row].getRosterIDs()[0]]!]?.getDisplayName())!
        }
        else {
            text = "Trade between: "
            for i in 0..<transactions![indexPath.row].getRosterIDs().count {
                text += (LeagueUsersModel.shared.usersIDToUsers[LeagueUsersModel.shared.rosterIDToUserID[transactions![indexPath.row].getRosterIDs()[i]]!]?.getDisplayName())! + " "
            }
        }
        cell.textLabel?.text = text
        
        return cell
    }
    
    // call Sleeper API to fetch transactions for week x, return nil if something goes wrong
    private func fetchTransactions(forWeek week: Int) async -> [Transaction]? {
        guard let url = URL(string: "https://api.sleeper.app/v1/league/\(LeagueIDViewController.leagueID)/transactions/\(week)") else {
            return nil
        }
        
        do {
            let (json, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([Transaction].self, from: json)
        } catch {
            return nil
        }
    }

}

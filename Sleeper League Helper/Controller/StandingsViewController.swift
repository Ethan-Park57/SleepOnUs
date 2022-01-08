
//
//  StandingsViewController.swift
//  Sleeper League Helper
//
//  Created by Ethan Park on 12/7/21.
// edpark@usc.edu
//

import UIKit
import Firebase
import Charts
import CodableFirebase

class StandingsViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var standingsBarChartView: BarChartView!
    @IBOutlet weak var showGraphButton: UIButton!
    @IBOutlet weak var standingsBarItem: UITabBarItem!
    
    
    private var wins = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showGraphButton.setTitle(NSLocalizedString("Show", comment: ""), for: .normal)
        Task.init {
            LeagueUsersModel.shared.nflState = await getNFLState()
        }
    }
    
    // when user taps show, then show chart
    @IBAction func showDidTapped(_ sender: UIButton) {
        sender.isHidden = true
        updateChart()
    }
    
    // call Sleeper API to fetch NFL information, return nil if something goes wrong
    private func getNFLState() async -> NFLState? {
        guard let url = URL(string: "https://api.sleeper.app/v1/state/nfl") else {
            return nil
        }
        
        do {
            let (json, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(NFLState.self, from: json)
        } catch {
            return nil
        }
    }
    
    // use Charts package to create a bar chart
    private func updateChart() {
        var data: [BarChartDataEntry] = []

        let usersArray = Array(LeagueUsersModel.shared.usersIDToUsers.values)
        for i in 0..<usersArray.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(usersArray[i].getWins() ?? 0))
            data.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: data, label: "Wins")
        let chartData = BarChartData(dataSet: chartDataSet)
        standingsBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: usersArray.map {$0.getDisplayName()})
        standingsBarChartView.xAxis.labelRotationAngle = -25
        standingsBarChartView.rightAxis.enabled = false

        standingsBarChartView.data = chartData
    }

}

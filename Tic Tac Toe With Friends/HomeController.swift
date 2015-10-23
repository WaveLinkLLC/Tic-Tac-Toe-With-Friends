//
//  HomeController.swift
//  Tic Tac Toe With Friends
//
//  Created by Kelvin Graddick on 10/17/15.
//  Copyright © 2015 Wave Link, LLC. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class HomeController: UITableViewController {

    private var games: [Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)
        automaticallyAdjustsScrollViewInsets = false;
        
        Alamofire.request(.GET, "http://www.wavelinkllc.com/tictactoewithfriends/get_games.php", parameters: ["userId": 2])
            .responseJSON { response in
                let dataArray: NSArray = (response.result.value as? NSArray)!
                for data in dataArray {
                    self.games.append(Game.init(JSONData: data as! Dictionary<String, AnyObject>))
                }
                self.tableView.reloadData()
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GameCell") as! GameCell
        let game: Game = games[indexPath.row]
        
        cell.profileImageView.af_setImageWithURL(NSURL(string: game.opponentPhoto)!, placeholderImage: UIImage(named: "Home"))
        cell.iconImageView.image = UIImage(named: "User")
        cell.nameLabel.text = game.opponentName
        
        switch GameStatus(rawValue: game.status)! {
            case .Unaccepted:
                cell.statusLabel.text = game.isPlayerOne ? "Waiting for them to accept." : "Accept the challenge!"
            case .PlayerOneTurn:
                cell.statusLabel.text = game.isPlayerOne ? "Your move!" : "Their move."
            case .PlayerTwoTurn:
                cell.statusLabel.text = game.isPlayerOne ? "Their move." : "Your move!"
            case .PlayerOneWon:
                cell.statusLabel.text = game.isPlayerOne ? "You won! Rematch?" : "They beat you. Rematch?"
            case .PlayerTwoWon:
                cell.statusLabel.text = game.isPlayerOne ? "They beat you. Rematch?" : "You won! Rematch?"
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
        switch indexPath.row {
        case 0...1: return 35
        case 2...4: return 65
        case 5: return 100
        default: return 150
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

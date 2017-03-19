//
//  ViewController.swift
//  Uiviewswitch
//
//  Created by Daniel Hjärtström on 2016-11-30.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.
//

import UIKit

enum LinkType: String {

    case contentset = "contentset"
    case menuitem = "menuitem"
    case resource = "resource"

}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let presentationSegue = "presentationSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let questionsArray: [String] = [
            "Whats the most unusual conversation you've ever had?",
            "Are you much of a gambler?",
            "Are you much of a daredevil?",
            "Are you a good liar?",
            "Are you a good judge of character?",
            "Are you any good at charades?",
            "How long could you go without talking?",
            "What has been your worst haircut/style?",
            "Can you iceskate?",
            "Can you summersault?",
            "Whats your favourite joke?"
        ]
        
     
        let string: String = "ipresent-app:///linktype=resource/contentset=@lazy%20wasp/menuitem=PDF%20Item/resource=html%20text%20file"
        
        let url: URL = URL(string: string)!
        
        let scheme: String = url.scheme!
       
        var type: LinkType? = nil
        
        let dictionary: [String:String]? = (url.pathComponents.filter { url.pathComponents.index(of: $0)! > 0 }).reduce([String:String]()) { (dict, value) -> [String: String]? in
            
            var dict = dict
            
            if (type == nil){
                
                type = LinkType(rawValue: value.components(separatedBy: "=")[1])
                
                return dict
            }
            
            let key = (value.components(separatedBy: "=")[0]).replacingOccurrences(of: "%20", with: " ")
            let val = (value.components(separatedBy: "=")[1]).replacingOccurrences(of: "%20", with: " ")
            
            dict?[key] = val
            
            return dict
        }
        
        
        
        Singleton.sharedInstance.questions = questionsArray
        Singleton.sharedInstance.pages = PDFContextCreationManager().returnContextForPDF()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == presentationSegue {
        
            let vc = segue.destination as! PresentationViewController
            vc.index = (tableView.indexPathForSelectedRow?.row)!
            
        }
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.sharedInstance.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let current = Singleton.sharedInstance.questions[indexPath.row]
        
        cell.textLabel?.text = "Question \(indexPath.row+1)"
        cell.detailTextLabel?.text = current
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: presentationSegue, sender: nil)
        
    }
}

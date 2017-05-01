//
//  ViewController.swift
//  Anagram Game
//
//  Created by Joshua Hudson on 4/30/17.
//  Copyright © 2017 ParanoidPenguinProductions. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        // Locate the file with the terms for the game
        if let startWords = Bundle.main.path(forResource: "start", ofType: "txt") {
            
            if let startWords = try? String(contentsOfFile: startWords) {
                
                allWords = startWords.components(separatedBy: "\n")
                
            } else {
                
                allWords = ["silkworm"]
                
            }
        }
        
        startGame()
        
    }
    
    func startGame() {
        
        // Shuffle the array
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
        title = allWords[0]
        
        // Reset the usedWords array on restart
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usedWords.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
        
    }
    
    func promptForAnswer() {
        
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        
        // Add editable text field to the UIAlertController
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] _ in
            
            // guard let answer = ac.textFields[0] else { return }
            let answer = ac.textFields![0]
            self.submit(answer: answer.text!)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    
    func submit(answer: String) {
        
        // Modify letter case to avoid for duplicate letters, ie C and c. Strings are case sensitive.
        let lowerAnswer = answer.lowercased()
        let errorTitle: String
        let errorMessage: String
        
        // if isPossible(word: lowerAnswer) && if isOriginal(word: lowerAnswer) && if isReal(word: lowerAnswer) { }
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    
                    usedWords.insert(answer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                    
                } else {
                    
                    errorTitle = "Word not recognized"
                    errorMessage = "That word isn't recognized by Anagram"
                    
                }
                
            } else {
                
                errorTitle = "Word already used"
                errorMessage = "You've previously found this word"
                
            }
            
        } else {
            
            errorTitle = "Word not possible"
            errorMessage = "You entered a word with a letter not found in \(title!.lowercased())"
            
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(ac, animated: true)
        
    }
    
    func isPossible(word: String) -> Bool {
        
        // Loop throw each letter and then remove that letter if it is included in the title word
        var tempWord = title!.lowercased()
        
        for letter in word.characters {
            
            if let pos = tempWord.range(of: String(letter)) {
                
                tempWord.remove(at: pos.lowerBound)
                
            } else {
                
                return false
                
            }
            
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        
        // Return the opposite of contains(word) Bool
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        // Returns true if the word is spelled correctly
        return misspelledRange.location == NSNotFound
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

































//
//  JokesTableViewController.swift
//  Comedy Notes
//
//  Created by Anna Shark on 9/9/21.
//

import UIKit
import CoreData

class JokesTableViewController: UITableViewController {

    var jokesArray = [Jokes]()
    var selectedStatus : Bool? {
        didSet {
            loadJokes()
        }
    }
    
//    var SelectedIndexPath = IndexPath()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadJokes()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jokesArray.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "jokeCell", for: indexPath)
        
        let joke = jokesArray[indexPath.row]
        cell.textLabel?.text = joke.text
        
        if joke.finished {
            cell.imageView?.image = UIImage(systemName: "circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        } else {
            cell.imageView?.image  = UIImage(systemName: "circle")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        }
        //cell.accessoryType = joke.finished ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            context.delete(jokesArray[indexPath.row])
            jokesArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    //MARK: - TableView Delegate methods
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
    //        context.delete(itemArray[c.row])
    //        itemArray.remove(at: indexPath.row)
            
            jokesArray[indexPath.row].finished = !jokesArray[indexPath.row].finished
            saveJokes()
            tableView.deselectRow(at: indexPath, animated: true)
            loadJokes()
            
        }
        
    //MARK: - Add and remove New Jokes
            
        
     
    @IBAction func addJokeButtonPressed(_ sender: UIBarButtonItem) {
    
    print("add button pressed")
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Add a new Joke", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add a joke", style: .default) { (action) in
                // what will happen once user clicks add item button on alert
                
               
                let newJoke = Jokes(context: self.context)
                newJoke.text = textField.text!
                newJoke.finished = false
                
                self.jokesArray.append(newJoke)
                
                self.saveJokes()
                
            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Type here your new joke"
                textField = alertTextField
            }
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
       
        }

    
    
    //MARK: - Model Manilupation Methods
        
        func saveJokes() {
            
            do {
                try context.save()
            } catch {
                print("Error saving context\(error)")
            }
            self.tableView.reloadData()
        }
        
        
        func loadJokes(with request: NSFetchRequest<Jokes> = Jokes.fetchRequest(), predicate: NSPredicate? = nil) {
            let statusPredicate = NSPredicate(format: "finished == %d", selectedStatus!)
            if let additionalPredicate = predicate {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [statusPredicate, additionalPredicate])
            } else {
                request.predicate = statusPredicate
            }

            do {
                jokesArray = try context.fetch(request)
            } catch {
                print("Error fetching data from context \(error)")
            }
            tableView.reloadData()
        }
    
}

//MARK: - SearchBar Delegate  Methods
extension JokesTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Jokes> = Jokes.fetchRequest()
        let predicate = NSPredicate(format: "text CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]

        loadJokes(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadJokes()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

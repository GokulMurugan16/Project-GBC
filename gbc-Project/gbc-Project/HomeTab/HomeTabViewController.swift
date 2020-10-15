//
//  HomeTabViewController.swift
//  gbc-Project
//
//  Created by Devjot Sandhu on 2020-10-10.
//
// API KEY - 5f96277317af4c929a9e43ae1c5b8cd2

import UIKit
import FirebaseAuth

class HomeTabViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: - Global Variables
    
    var articles = [Article]()
    
    // MARK: - Outlets
    
    @IBOutlet weak var newsTableViewOutlet: UITableView!
    
    // MARK: - Default Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        self.newsTableViewOutlet.dataSource = self
        self.newsTableViewOutlet.delegate = self

        downloadData()
    }
    
    // MARK: - TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = newsTableViewOutlet.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath)
        //let article = articles[indexPath.row]
        cell.textLabel?.text = "article.title goes here..."
        //print(article.title)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 30, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0.5
        
        UIView.animate(withDuration: 0.75) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    
    
    // MARK: - Data Download Functions
    
    // Function to download data from NewsAPI
    func downloadData() {
        
        let urlString = "http://newsapi.org/v2/top-headlines?country=ca&sortBy=publishedAt&apiKey=5f96277317af4c929a9e43ae1c5b8cd2"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url){
                parse(json: data)
            }
        }
    }
    
    // Function to parse JSON
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let newsArticles = try? decoder.decode(Articles.self, from: json){
            articles = newsArticles.articles
            newsTableViewOutlet.reloadData()
        }
    }
    
    // MARK: Segue Functions
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        print("Log out Button Pressed")
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
      
    }
    
    

   
    

}
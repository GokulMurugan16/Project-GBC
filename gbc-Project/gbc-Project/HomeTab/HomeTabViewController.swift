//
//  HomeTabViewController.swift
//  gbc-Project
//
//  Created by Devjot Sandhu on 2020-10-10.
//
// API KEY - 5f96277317af4c929a9e43ae1c5b8cd2

import UIKit

class HomeTabViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: - Global Variables
    
    var articles = [article]()
    
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
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = newsTableViewOutlet.dequeueReusableCell(withIdentifier: "customTableCell", for: indexPath)
        let article = articles[indexPath.row]
        cell.textLabel?.text = article.author
        
        return cell
    }
    
    
    // MARK: - Data Download Functions
    
    // Function to download data from NewsAPI
    func downloadData() {
        
        let urlString = "http://newsapi.org/v2/everything?q=student&sortBy=publishedAt&country=ca&apiKey=5f96277317af4c929a9e43ae1c5b8cd2"
        
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
    

   
    

}

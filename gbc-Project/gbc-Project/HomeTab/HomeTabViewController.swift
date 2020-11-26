//
//  HomeTabViewController.swift
//  gbc-Project
//
//  Created by Devjot Sandhu on 2020-10-29.
//

import UIKit
import Firebase


class HomeTabViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: - Global Variables
    
    var articles = [Article]()
    var handle: AuthStateDidChangeListenerHandle?
    var userId:String?
    var userName:String?
    var db:Firestore!
    
    // MARK: - Outlets
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var newsTableViewOutlet: UITableView!
    
    
    // MARK: - Default Functions

    override func viewWillAppear(_ animated: Bool) {
        
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            let user = Auth.auth().currentUser
            if let user = user {
                self.userId = user.uid
                self.getUserData()
            }
        })
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newsTableViewOutlet.dataSource = self
        self.newsTableViewOutlet.delegate = self
        db = Firestore.firestore()

        //downloadData()
        if let localData = self.readLocalFile(forName: "data") {
            self.parse(json: localData)
        }
    }
    
    // MARK: - TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = newsTableViewOutlet.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! newsCell
        let article = self.articles[indexPath.row]
        cell.newsDescription.text = article.title
        cell.newsDescription.numberOfLines = 0
        print("\(article.urlToImage)")
        
        let url = URL(string: article.urlToImage)
        UIImage.loadFrom(url: url!) { (i) in
            cell.newsImage.image = i
        }
        
        return cell
    }
   
    /*
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 30, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0.5
        
        UIView.animate(withDuration: 0.75) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
 */
    
    
    // MARK: - Data Download Functions
    
    // Function to download data from NewsAPI
    func downloadData() {
        
        let urlString = "https://newsapi.org/v2/top-headlines?country=ca&sortBy=publishedAt&apiKey=5f96277317af4c929a9e43ae1c5b8cd2"
        
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
            self.articles = newsArticles.articles
            print(self.articles)
            newsTableViewOutlet.reloadData()
        }
    }
    
    func readLocalFile(forName name: String) -> Data? {
        
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
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
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    
    // MARK: User Data Functions
    
    func getUserData() {
        let docRef: Void = db.collection("users").whereField("userId", isEqualTo: userId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error Getting Documents \(err)")
                }
                else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data()) ")
                        let data = document.data()
                        
                        self.userName = (data["userName"] as! String?)!
                        self.welcomeLabel.text = "Welcome, \(self.userName!)"
                    }
                }
            }
    }

   
    

}

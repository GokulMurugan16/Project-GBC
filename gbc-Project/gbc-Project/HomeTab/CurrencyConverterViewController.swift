//
//  CurrencyConverterViewController.swift
//  gbc-Project
//
//  Created by Devjot Sandhu on 2020-10-15.
//

import UIKit

class CurrencyConverterViewController: UIViewController {
    
    private var results: CurrencyRates?

    // MARK: DEFAULT FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Data Load Functions
    
    func loadData() {
           guard let url = URL(string: "https://api.exchangeratesapi.io/latest?base=CAD&symbols=USD,GBP,INR") else {
               print("Invalid URL")
               return
           }
           let request = URLRequest(url: url)
           URLSession.shared.dataTask(with: request) { data, response, error in
               // below is step 4
               if let data = data {
                   if let decodedResponse = try? JSONDecoder().decode(CurrencyRates.self, from: data) {
                       // we have good data – go back to the main thread
                       DispatchQueue.main.async {
                           // update our UI
                           self.results = decodedResponse
                        print(self.results!)
                       }

                       // everything is good, so we can exit
                       return
                   }
               }

               // if we're still here it means there was a problem
               print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")

           }.resume()

       }
    
    
    
    // MARK: Segue Functions
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
    }
    

   

}

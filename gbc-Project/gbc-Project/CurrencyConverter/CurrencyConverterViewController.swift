//
//  CurrencyConverterViewController.swift
//  gbc-Project
//
//  Created by Devjot Sandhu on 2020-10-29.
//

import UIKit

class CurrencyConverterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource{
    
    // MARK: Variables
    
    private var results: CurrencyRates?
    private var currencyDict : [String:Double] = [:]
    private var baseRate: Double = 1.0
    private var selectedCurrency: String = "CAD"
    private var country : [(code: String, name: String)] = [
        ("CAD","Canadian Dollar"),
        ("USD","US Dollar"),
        ("AUD","Australian Dollar"),
        ("EUR","Euro"),
        ("BRL","Brazilian Real"),
        ("CNY","Yuan Renminbi"),
        ("NZD","New Zealand Dollar"),
        ("CUP","Cuban Peso"),
        ("EGP","Egyptian Pound"),
        ("GBP","Pound Sterling"),
        ("HKD","Hong Kong Dollar"),
        ("INR","Indian Rupee"),
        ("CHF","Swiss Franc"),
        ("JPY","Yen"),
        ("IDR","Indonesian Rupiah")
    ]
    
    // MARK: Constraints
    
    @IBOutlet weak var currencyConvLabelCenterConstraint: NSLayoutConstraint!
  
    // MARK: Outlets
    
    @IBOutlet weak var countryPV: UIPickerView!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var resultTableV: UITableView!
    
    // MARK: DEFAULT FUNCTIONS
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func tap(_ sender: Any) {
        
        view.endEditing(true)
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        resultTableV.allowsSelection = false
        resultTableV.showsVerticalScrollIndicator = false
        // Do any additional setup after loading the view.
    }
    
    // MARK: TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = results {
            return data.rates.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        if let data = results {
            //let CC = Array(data.rates.keys)[indexPath.row]
            cell.textLabel?.text = Array(data.rates.keys)[indexPath.row]
            let selectedRate = baseRate * Array(data.rates.values)[indexPath.row]
            cell.detailTextLabel?.text = "\(selectedRate.round(to: 2))"
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: PickerView Function
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return country.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(country[row].code) - \(country[row].name)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = country[row].code
        print(selectedCurrency)
    }
    
    // MARK: Data Load Functions
    
    func loadData() {
        
           guard let url = URL(string: "https://api.exchangeratesapi.io/latest?base=\(selectedCurrency)") else {
               print("Invalid URL")
               return
           }
           let request = URLRequest(url: url)
           URLSession.shared.dataTask(with: request) { data, response, error in
               
               if let data = data {
                   if let decodedResponse = try? JSONDecoder().decode(CurrencyRates.self, from: data) {
                       
                       DispatchQueue.main.async {
                           
                        self.results = decodedResponse
                        self.currencyDict = self.results!.rates
                        self.resultTableV.reloadData()
                       }
                       return
                   }
               }
               print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")

           }.resume()

       }
    
    // MARK: Button Functions
    @IBAction func convertPressed(_ sender: UIButton) {
        loadData()
        
        if let inputValue = amountTF.text {
            if let amount = Double(inputValue){
                baseRate = amount
            }
        }
        resultTableV.reloadData()
    }
    
    
    // MARK: Segue Functions
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
    }
    
}

// MARK: Extension

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

//
//  CurrencyConverterViewController.swift
//  gbc-Project
//
//  Created by Devjot Sandhu on 2020-10-29.
//

import UIKit

class CurrencyConverterViewController: UIViewController {
    
    // MARK: Variables
    
    private var results: CurrencyRates?
    private var currencyDict : [String:Double] = [:]
    private var activeCurrency: Double = 0.0
    
    // MARK: Constraints
    
    @IBOutlet weak var currencyConvLabelCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentCtrlCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputAmountCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var convertButtonCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var outputLabelCenterConstraint: NSLayoutConstraint!
    
    // MARK: Outlets
    
    @IBOutlet weak var currencySegmentControl: UISegmentedControl!
    @IBOutlet weak var exchangeRateLabel: UILabel!
    @IBOutlet weak var inputAmount: UITextField!
    @IBOutlet weak var outputAmountLabel: UILabel!
    
    // MARK: DEFAULT FUNCTIONS
    
    override func viewWillAppear(_ animated: Bool) {
        currencyConvLabelCenterConstraint.constant -= view.bounds.width
        segmentCtrlCenterConstraint.constant -= view.bounds.width
        inputAmountCenterConstraint.constant -= view.bounds.width
        convertButtonCenterConstraint.constant -= view.bounds.width
        outputLabelCenterConstraint.constant -= view.bounds.width
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Currency Converter Label Animation
        currencyConvLabelCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options:.curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
          }, completion: nil)
        
        // Segment Control Animation
        segmentCtrlCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0.3,
                       options:.curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
          }, completion: nil)
        
        // Input Amount Animation
        inputAmountCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0.3,
                       options:.curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
          }, completion: nil)
        
        // Convert Button Animation
        convertButtonCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0.5,
                       options:.curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
          }, completion: nil)
        
        // Output Label Animation
        outputLabelCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0.5,
                       options:.curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
          }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exchangeRateLabel.text = ""
        outputAmountLabel.text = ""
        loadData()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Button Function
    
    @IBAction func convertButtonPressed(_ sender: Any) {
        
        print("Convert Button Pressed")
        
        if (inputAmount.text == "")
        {
            let alert = UIAlertController(title: "Error", message: "Enter a valid amount.", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            outputAmountLabel.text = String((Double(inputAmount.text!)! / activeCurrency).round(to: 2)) + " CAD"
        }
    }
    
    // MARK: Segment Functions
    
    @IBAction func currencyChanged(_ sender: Any) {
        
        switch currencySegmentControl.selectedSegmentIndex
        {
        case 0:
            print ("Indian Rupee selected");
            exchangeRateLabel.text = "1 CAD = " + String(currencyDict["INR"]!.round(to: 2)) + " Indian Rupees"
            activeCurrency = currencyDict["INR"]!.round(to: 2)
            break
            
        case 1:
            print("US Dollar selected")
            exchangeRateLabel.text = "1 CAD = " + String(currencyDict["USD"]!.round(to: 2)) + " US Dollar"
            activeCurrency = currencyDict["USD"]!.round(to: 2)
            break

        case 2:
            print("British Pound selected")
            exchangeRateLabel.text = "1 CAD = " + String(currencyDict["GBP"]!.round(to: 2)) + " British Pound"
            activeCurrency = currencyDict["GBP"]!.round(to: 2)
            break
            
        default:
            print("None selected")
            break
        }
    }
    
    // MARK: Data Load Functions
    
    func loadData() {
        
           guard let url = URL(string: "https://api.exchangeratesapi.io/latest?base=CAD&symbols=USD,GBP,INR") else {
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
                       
                       }
                       return
                   }
               }
               print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")

           }.resume()

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

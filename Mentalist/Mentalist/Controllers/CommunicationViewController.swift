//
//  CommunicationViewController.swift
//  Mentalist
//
//  Created by Juliette Bois on 16.02.21.
//

import UIKit
import StringMetric

class CommunicationViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {

    @IBOutlet weak var myCollection: UICollectionView!
    @IBOutlet weak var myResponse: UITextField!
    var cellList:[String] = []
    var separatedStrings: [String] = []
    var cases:Int = 1
    var content:String = ""
    var pasContent:String = ""
    var pourquoiDMII:String = ""
    
    var historyHelper = HistoryHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let paddingView: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5)
//        myResponse.leftView = paddingView
//        myResponse.leftViewMode = .always
        
        myResponse.delegate = self

        // Do any additional setup after loading the view.
        hideKeyboardWhenTappedAround()
        myCollection.delegate = self
        myCollection.dataSource = self
        myCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "label")
    }
    
    @IBAction func sendResponse(_ sender: Any) {
        print("write func")
        if let data = myResponse.text?.data(using: .utf8) {
            write(data: data)
        }
    }
    
    func write(data: Data) {
        BLEManager.instance.sendData(data: data) { (success) in
            print(data)
        }
        
        historyHelper.sent(string: String(data: data, encoding: .utf8)!)
    }
    
    @IBAction func readData(_ sender: Any) {
        print("read func")
        BLEManager.instance.listenForMessages(UUID: "B2DBA4DB-6C7B-4649-A66D-2308B7BB835F", callback: { [self] (data) in
            if let deballe = data {
                let str = String(data: deballe, encoding: .utf8)!
                print(str)
                cellList.append(str)
                historyHelper.received(string: str)
                myCollection.reloadData()
                
                switch cases {
                case 1:
                    let splits = str.components(separatedBy: ":")
                    for split in splits {
                        self.write(data: split.data(using: .utf8)!)
                    }
                case 2:
                    let splits = str.components(separatedBy: ":").reversed()
                    for split in splits {
                        self.write(data: split.data(using: .utf8)!)
                    }
                case 3:
                    let splits = str.components(separatedBy: ":")
                    content = splits[0]
                    pasContent = splits[1]
                    pourquoiDMII = splits[2]
                    self.write(data: "OK".data(using: .utf8)!)
                case 4:
                    let distContent = content.distance(between: str)
                    let distPasContent = pasContent.distance(between: str)
                    let distPourquoiDMII = pourquoiDMII.distance(between: str)
                    switch min(distContent, distPasContent, distPourquoiDMII) {
                    case distContent:
                        self.write(data: "content".data(using: .utf8)!)
                    case distPasContent:
                        self.write(data: "pas content".data(using: .utf8)!)
                    case distPourquoiDMII:
                        self.write(data: "pourquoi j'ai choisi DMII?".data(using: .utf8)!)
                    default:
                        break
                    }
                default:
                    break
                }
                cases += 1
            }
        })
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: (view.frame.width-110)/2, height: 40)
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "label",for: indexPath)
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height))
        title.text = cellList[indexPath.row]
        title.font = UIFont(name: "AvenirNext-Bold", size: 15)
        title.textAlignment = .center
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.contentView.addSubview(title)
        cell.layer.borderWidth=0.5
        cell.layer.cornerRadius = 8
        cell.layer.borderColor = UIColor.gray.cgColor

        return cell
    }
}

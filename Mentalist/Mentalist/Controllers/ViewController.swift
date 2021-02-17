//
//  ViewController.swift
//  Mentalist
//
//  Created by Juliette Bois on 16.02.21.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var periphReady: Bool = false
    var periph: CBPeripheral?
    var cellList:[String] = []
    
    @IBAction func scanClicked(_ sender: Any) {
        BLEManager.instance.scan { periph, name in
            if name == "juliette" {
                BLEManager.instance.stopScan()
                BLEManager.instance.connectPeripheral(periph) { per in
                
                    self.periph = periph
                    
                    BLEManager.instance.discoverPeripheral(per) { (periphReady) in
                        self.periphReady = true
                    }
                }
            }
            self.cellList.append(name)
            self.myTable.reloadData()
        }
    }
    
    @IBOutlet weak var myTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTable.delegate = self
        myTable.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cellList[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
}


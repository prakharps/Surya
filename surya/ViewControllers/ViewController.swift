//
//  ViewController.swift
//  surya
//
//  Created by Prakhar Srivastava on 04/03/19.
//  Copyright © 2019 Prakhar Srivastava. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let requestUrl = "http://surya-interview.appspot.com/list"
    var list:[Item]?
    //var list:List?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 65
        let prefs = UserDefaults.standard
        guard let items = prefs.data(forKey: "list") else{
            tableView.isHidden = true
            return
        }
        let decoder = JSONDecoder()
        list = try? decoder.decode([Item].self,from: items )
        if(list!.count > 0){
            tableView.isHidden = false
            }
//        guard let items = list else {
//            tableView.isHidden = true
//            return
//        }
//        if(items.count > 0){
//            tableView.isHidden = false
//        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func submit(_ sender: UIButton) {
        guard let email = emailText.text else {
            return
        }
        tableView.isHidden = true
        //StaticDataMembers.email = email
        let parameters:[String:String] = ["emailId":email]
        let headers = ["Content-Type":"application/json"]
        Alamofire.request(requestUrl,method: .post, parameters:parameters,encoding: JSONEncoding.default,headers: headers).responseJSON{ response in
            switch response.result{
            case .success(let value):
                //success call
                let jsonData = response.result.value
                let data = jsonData! as! NSDictionary
                let listData = data.value(forKey: "items") as! NSArray
                let listJsonData = try? JSONSerialization.data(withJSONObject: listData, options: .prettyPrinted)
                let decoder = JSONDecoder()
                //let data = response.data!
                self.list = try? decoder.decode([Item].self,from: listJsonData! )
                //self.list = try? decoder.decode(List.self,from: listJsonData! )
                self.tableView.isHidden = false
                self.tableView.reloadData()
                UserDefaults.standard.set(listJsonData!, forKey: "list")
                //StaticDataMembers.list = list
                break
            case .failure(let error):
                //failure callback
                print(error)
            }
        }
    }
    

}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = list else{
            return 0
        }
        //return items.item.count
        return list!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "items", for: indexPath) as! TableViewCell
        let index = indexPath.row
        //var item = list?.item[index]
        var item = list?[index]
        Alamofire.request((item?.imageUrl)!).responseImage{ response in
            if let image = response.result.value{
                cell.userImage.image = image
            }
        }
        cell.firstName.text = item?.firstName
        cell.lastName.text = item?.lastName
        cell.email.text = item?.emailId
        return cell
    }
}


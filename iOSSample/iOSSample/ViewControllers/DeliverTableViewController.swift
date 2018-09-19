//
//  ViewController.swift
//  iOSSample
//
//  Created by apple on 9/18/18.
//  Copyright © 2018 ken. All rights reserved.
//

import UIKit
import AlamofireImage
import PKHUD

class DeliverTableViewController: UITableViewController {
    
    var deliverArray:[Deliver] = [Deliver]()
    
    let deliverRefreshControl = UIRefreshControl()
    let loadmoreView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    let pageSize = 20
    
    public enum LoadingState : Int {
        case none
        case loadNew
        case loadMore
    }
    
    var hasMore = true
    
    var loadingState = LoadingState.none

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // setting navigation bar
        title = "Things to Deliver"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.tintColor = UIColor.black        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // setting tableview
        tableView.register(DeliverTableViewCell.self, forCellReuseIdentifier: "DeliverCell")
        tableView.refreshControl = deliverRefreshControl
        deliverRefreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        deliverRefreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        
        // loadData
        deliverRefreshControl.beginRefreshing()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loadData() {
        if loadingState != .none {
            return
        }
        loadingState = .loadNew
        hasMore = true
        DispatchQueue.main.async {
            HttpClient.getDelivers(offset: 0, limit: self.pageSize, callback: { (delivers) in
                self.deliverRefreshControl.endRefreshing()
                self.deliverArray.removeAll()
                self.deliverArray.append(contentsOf: delivers)
                self.tableView.reloadData()
                self.loadingState = .none
                if delivers.count < self.pageSize {
                    self.hasMore = false
                    self.tableView.tableFooterView = nil
                }else{
                    self.tableView.tableFooterView = self.loadmoreView
                }
            })
        }
    }
    
    @objc func loadMore() {
        if loadingState != .none {
            return
        }
        if hasMore == false {
            self.loadmoreView.stopAnimating()
        }
        loadingState = .loadMore
        DispatchQueue.main.async {
            HttpClient.getDelivers(offset: self.deliverArray.count, limit: self.pageSize, callback: { (delivers) in
                self.deliverRefreshControl.endRefreshing()
                self.deliverArray.append(contentsOf: delivers)
                self.tableView.reloadData()
                self.loadmoreView.stopAnimating()
                self.loadingState = .none
                if delivers.count < self.pageSize {
                    self.hasMore = false
                    self.tableView.tableFooterView = nil
                }else{
                    self.tableView.tableFooterView = self.loadmoreView
                }
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliverArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deliver = deliverArray[indexPath.row]
        let detailVC = DetailDeliverViewController()
        detailVC.deliver = deliver
        show(detailVC, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliverCell", for: indexPath) as! DeliverTableViewCell
        let deliver = deliverArray[indexPath.row]
        let url = URL(string: deliver.imageUrl)
        cell.imageView?.af_setImage(withURL: url!, placeholderImage: UIImage(named: "img_default"))
        cell.textLabel?.text = deliver.desc
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        print("willDisplayFooterView")
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == deliverArray.count - 1 {
            print("willDisplay")
            if hasMore {
                loadmoreView.startAnimating()
                loadMore()
            }
        }
    }
}

class DeliverTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = bounds.size
        imageView?.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
        imageView?.layer.cornerRadius = 20
        imageView?.clipsToBounds = true
        textLabel?.frame = CGRect(x: 65, y: 10, width: size.width - 120, height: 40)
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
    }
}


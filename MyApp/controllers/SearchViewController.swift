//
//  SearchViewController.swift
//  MyApp
//
//  Created by 武井優弥 on 2020/07/25.
//  Copyright © 2020 euyah.com. All rights reserved.
//
import UIKit
import NCMB
import PKHUD
import Kingfisher

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, SearchTableViewCellDelegate {
    
    
    //var posts = [Post]()
    var posts = [NCMBObject]()
    //ブロック機能
    var blockUserIdArray = [String]()
    var lists = [String]()
    var listArray = [[String]]()
    var users = [NCMBUser]()
    
    // サーチViewControllerに渡す値
    //何も書いてないけど、値が入ることになってる（ここに入るのはString)
    //””ここに””direction
    var giveShowTL = ""
    
    var searchBar: UISearchBar!
    
    @IBOutlet var searchTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.tableFooterView = UIView()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        let nib = UINib(nibName: "SearchTableViewCell", bundle: Bundle.main)
        searchTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        //setRefreshControl()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setSearchBar()
        searchPost(searchText: nil)
        loadTimeline()

        
        //func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        //押してユーザーの詳細に飛ぶやつ今回は省略
        //let showUserViewController = segue.destination as! ShowUserViewController
        //let selectedIndex = searchTableView.indexPathForSelectedRow!
        //showUserViewController.selectedUser = users[selectedIndex.row]
        // }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //検索する
        searchPost(searchText: searchText)
        searchTableView.reloadData()
        print(searchText)
        print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy")
    }
    
    func setSearchBar() {
        // NavigationBarにSearchBarをセット
        if let navigationBarFrame = self.navigationController?.navigationBar.bounds {
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            searchBar.placeholder = "検索"
            searchBar.autocapitalizationType = UITextAutocapitalizationType.none
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.searchBar = searchBar
        }
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchPost(searchText: nil)
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchPost(searchText: searchBar.text)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(posts.count)
        print("rrrrrrrrrrrrrrrrrrrrrrrrrr")
        
        return posts.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //ここで
        giveShowTL = posts[indexPath.row].object(forKey: "direction") as! String
        
        //TableView押した時に画面遷移
        self.performSegue(withIdentifier: "toT", sender: nil)
        //遷移したら押されたのを解除する
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    // ①セグエ実行前処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // ②Segueの識別子確認
        if segue.identifier == "toT" {
            
            // ③遷移先ViewCntrollerの取得
            let nextView = segue.destination as! ShowTimelineViewController
            
            // ④値の設定（次のVCに値渡す）
            nextView.receiveSearchTL = giveShowTL
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SearchTableViewCell
        
        cell.delegate = self
        cell.tag = indexPath.row
        cell.selectionStyle = .none
        
        
        cell.directionLabel!.text = posts[indexPath.row].object(forKey: "direction") as! String
        //cell.directionLabel!.text = posts[indexPath.row].direction　元々のやつ
        
        
        
        let user = posts[indexPath.row].object(forKey: "user") as! NCMBUser
        //let user = posts[indexPath.row].user  元々のやつ
        
        // ユーザー画像　⚠️投稿時の写真になってる？
             let file = NCMBFile.file(withName: user.objectId, data: nil) as! NCMBFile
             file.getDataInBackground { (data, error) in
                 if error != nil {
                     //cell.userImageView.layer.cornerRadius = cell.userImageView.bounds.width / 2.0
                     cell.userimageView2.layer.masksToBounds = true
                     cell.userimageView2.backgroundColor = UIColor(displayP3Red: 93/255, green: 167/255, blue: 151/255, alpha: 1.0)
                 } else {
                     if data != nil {
                         let image = UIImage(data: data!)
                         cell.userimageView2.image = image
                         //cell.userImageView.layer.cornerRadius = cell.userImageView.bounds.width / 2.0
                         cell.userimageView2.layer.masksToBounds = true
                     }
                 }
             }
             
        
        
        
        
        
        
        
        
        
        
        let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/QYEIUecMOiGT2A6H/publicFiles/" + user.objectId
        
        cell.userimageView2.kf.setImage(with: URL(string: userImageUrl), placeholder: UIImage(named: "placeholder.jpg"))
        
        return cell
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func searchPost(searchText: String?) {
        let query = NCMBQuery(className: "Post")
        // 降順（この場合投稿された順ってこと）
        query?.order(byDescending: "createDate")
        query?.includeKey("user")
        
        //query?.whereKey("direction", equalTo: searchText)
        
        
        // 検索ワードがある場合
        if let text = searchText {
            print(text)
            print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
            //let query1 = NCMBQuery(className: "Post")
            //query1?.whereKey("direction", equalTo: text)
            
            query?.whereKey("direction", equalTo: text)
        }
        
        
        
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                // SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                self.posts = [NCMBObject]()
                // 取得した新着50件のユーザーを格納
                for postObject in result as! [NCMBObject]{
                    let user = postObject.object(forKey: "user")as! NCMBUser
                    if  user.object(forKey: "active") as! Bool != false{
                        self.posts.append(postObject)
                        
                    }
                }
                self.searchTableView.reloadData()
                
            }
        })
        
        
    }
    
    func loadTimeline() {
        
        guard let currentUser = NCMBUser.current() else {
            //ログインに戻る
            //ログアウト登録成功
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let RootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = RootViewController
            //ログアウト状態の保持
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
            return
        }
        
        
        
        let query = NCMBQuery(className: "Post")
        
        // 降順（この場合投稿された順ってこと）
        query?.order(byDescending: "createDate")
        
        // 投稿したユーザーの情報も同時取得
        query?.includeKey("user")
   
        // フォロー中の人 + 自分の投稿だけ持ってくる
        //query?.whereKey("user", containedIn: followings)
        
        // オブジェクトの取得　findObject で拾ってきてる
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                //        SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)同じ内容が重複しないように
                // self.posts = [Post]()
                
                
                
                //                 self.posts = result as! [NCMBObject]
                print(result)
                
                self.posts = [NCMBObject]()
                
                //とってきた値をNCMBObjectの配列にダウンキャストしてる　それをfor in 文で一個一個取り出してる
                for postObject in result as! [NCMBObject] {
                    // ユーザー情報をUserクラスにセット
                    let user = postObject.object(forKey: "user") as! NCMBUser
                    
                    // 退会済みユーザーの投稿を避けるため、activeがfalse以外のモノだけを表示
                    
                    print(user.object(forKey: "active")as? Bool)
                    
                    print("eeeeeeeeee")
                    
                    
                    if user.object(forKey: "active") as? Bool != false  {
                        
                        print(user)
                        self.posts.append(postObject)
                        
                        
                        // 投稿したユーザーの情報をUserモデルにまとめる
                        let userModel = User(objectId: user.objectId, userName: user.userName)
                        userModel.displayName = user.object(forKey: "displayName") as? String
                        
                        // 投稿の情報を取得
                        let imageUrl = postObject.object(forKey: "imageUrl") as! String
                        
                        let text = postObject.object(forKey: "text") as! String
                      
                        let direction = postObject.object(forKey: "direction") as! String
                        // 2つのデータ(投稿情報と誰が投稿したか?)を合わせてPostクラスにセット
                        let post = Post(objectId: postObject.objectId, user: userModel, imageUrl: imageUrl, text: text, createDate: postObject.createDate, direction:direction)
                  
                        // likeの状況(自分が過去にLikeしているか？)によってデータを挿入
                        //let likeUsers = postObject.object(forKey: "likeUser") as? [String]
                        //if likeUsers?.contains(NCMBUser.current().objectId) == true {
                        // post.isLiked = true
                        //} else {
                        // post.isLiked = false
                        //}
                        
                        
                        // いいねの件数
                        //                        if let likes = likeUsers {
                        //                            post.likeCount = likes.count
                        //                        }
                        //
                        //                         配列に加える
                        //                        self.posts.append(post)
                        
                                     
                    }
                }
                
                // 投稿のデータが揃ったらTableViewをリロード
                self.searchTableView.reloadData()
            }
        })
    }
    
    
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        searchTableView.addSubview(refreshControl)
    }
    
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        //self.loadFollowingUsers()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
}

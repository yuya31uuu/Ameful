//
//  UserPageViewController.swift
//  MyApp
//
//  Created by 武井優弥 on 2020/06/24.
//  Copyright © 2020 euyah.com. All rights reserved.
//

import UIKit
import NCMB
import Kingfisher
//import SVProgressHUD
import SwiftDate

class UserPageViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,TimelineTableViewCellDelegate {
    func didTapMenuButton(tableViewCell: UITableViewCell, button: UIButton) {
        
    }
    
    
    var posts = [Post]()
    
    @IBOutlet var timelineTableView: UITableView!
    @IBOutlet var userImageview:UIImageView!
    @IBOutlet var userDisplayNameLabel: UILabel!
    @IBOutlet var button: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineTableView.dataSource = self
        timelineTableView.delegate = self
        
        
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle.main)
        timelineTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        timelineTableView.tableFooterView = UIView()
        
         self.button.layer.cornerRadius = 10.0
        
        
        // 引っ張って更新
        setRefreshControl()
        
        // フォロー中のユーザーを取得する。その後にフォロー中のユーザーの投稿のみ読み込み
        loadTimeline()
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 578
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TimelineTableViewCell
        
        cell.delegate = self
        cell.tag = indexPath.row
        
        
        let user = posts[indexPath.row].user
        cell.userNameLabel.text = user.displayName
        
         cell.postTextView.text = posts[indexPath.row].text
        
        
        
        cell.directionLabel.text = posts[indexPath.row].direction
        
        
        
        
        let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/QYEIUecMOiGT2A6H/publicFiles/" + user.objectId
        cell.userImageView.kf.setImage(with: URL(string: userImageUrl), placeholder: UIImage(named: "placeholder.jpg"))
        
        
        let imageUrl = posts[indexPath.row].imageUrl
        cell.photoImageView.kf.setImage(with: URL(string: imageUrl))
        // Likeによってハートの表示を変える
        if posts[indexPath.row].isLiked == true {
            cell.likeButton.setImage(UIImage(named: "star-fill"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(named: "star-outline"), for: .normal)
        }
        
        // Likeの数
        cell.likeCountLabel.text = "\(posts[indexPath.row].likeCount)件"
        
        // タイムスタンプ(投稿日時) (※フォーマットのためにSwiftDateライブラリをimport)
        cell.timestampLabel.text = posts[indexPath.row].createDate as? String
        
        
        
        
        
        
        return cell
    }
    func didTapLikeButton(tableViewCell: UITableViewCell, button: UIButton) {
        
        
        
        
        if posts[tableViewCell.tag].isLiked == false || posts[tableViewCell.tag].isLiked == nil {
            let query = NCMBQuery(className: "Post")
            query?.getObjectInBackground(withId: posts[tableViewCell.tag].objectId, block: { (post, error) in
                post?.addUniqueObject(NCMBUser.current().objectId, forKey: "likeUser")
                post?.saveEventually({ (error) in
                    if error != nil {
                        //                       SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    } else {
                        self.loadTimeline()
                    }
                })
            })
        } else {
            let query = NCMBQuery(className: "Post")
            query?.getObjectInBackground(withId: posts[tableViewCell.tag].objectId, block: { (post, error) in
                if error != nil {
                    //                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    post?.removeObjects(in: [NCMBUser.current().objectId], forKey: "likeUser")
                    post?.saveEventually({ (error) in
                        if error != nil {
                            //                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            self.loadTimeline()
                        }
                    })
                }
            })
        }
    }
    
    func loadTimeline() {
        let query = NCMBQuery(className: "Post")
        
        // 投稿したユーザーの情報も同時取得
        query?.includeKey("user")

        
        //いいねしたやつ表示
        query?.whereKey("likeUser", equalTo: NCMBUser.current()?.objectId)
        
        // 降順
        query?.order(byDescending: "createDate")
        

        
        
        
        // フォロー中の人 + 自分の投稿だけ持ってくる
        //query?.whereKey("user", containedIn: followings)
        
        // オブジェクトの取得
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                //                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)
                self.posts = [Post]()
                print(result)
                for postObject in result as! [NCMBObject] {
                    // ユーザー情報をUserクラスにセット
                    let user = postObject.object(forKey: "user") as! NCMBUser
                    
                    // 退会済みユーザーの投稿を避けるため、activeがfalse以外のモノだけを表示
                    if user.object(forKey: "active") as? Bool != false {
                        // 投稿したユーザーの情報をUserモデルにまとめる
                        let userModel = User(objectId: user.objectId, userName: user.userName)
                        userModel.displayName = user.object(forKey: "displayName") as? String
                        
                        // 投稿の情報を取得
                        let imageUrl = postObject.object(forKey: "imageUrl") as! String
                        
                        let text = postObject.object(forKey: "text") as! String
//                        let textView = postObject.object(forKey: "textView") as! String
                        let direction = postObject.object(forKey: "direction") as! String
                               // 2つのデータ(投稿情報と誰が投稿したか?)を合わせてPostクラスにセット
                               let post = Post(objectId: postObject.objectId, user: userModel, imageUrl: imageUrl, text: text, createDate: postObject.createDate, direction:direction)
                        
                        // likeの状況(自分が過去にLikeしているか？)によってデータを挿入
                        let likeUsers = postObject.object(forKey: "likeUser") as? [String]
                        if likeUsers?.contains(NCMBUser.current().objectId) == true {
                            post.isLiked = true
                        } else {
                            post.isLiked = false
                        }
                        
                        
                        // いいねの件数
                        if let likes = likeUsers {
                            post.likeCount = likes.count
                        }
                        
                        // 配列に加える
                        self.posts.append(post)
                    }
                }
                
                // 投稿のデータが揃ったらTableViewをリロード
                self.timelineTableView.reloadData()
            }
        })
    }
    
    
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        timelineTableView.addSubview(refreshControl)
    }
    
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        //self.loadFollowingUsers()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let user = NCMBUser.current(){
            userDisplayNameLabel.text = user.object(forKey: "displayName") as? String
            
            
        }
        loadTimeline()
        //ここやってないところ
        
        
        
        
        
        
        
        
        let file = NCMBFile.file(withName:NCMBUser.current().objectId  , data:nil) as! NCMBFile
        file.getDataInBackground { (data, error) in
            if error != nil {
                print(error)
            } else {
                if data != nil {
                    let image = UIImage(data: data!)
                    self.userImageview.image = image
                    
                }
                
                
            }
        }
        
        
        
        
        
        
    }
    @IBAction func showMenu(){
        let alertController = UIAlertController(title: "メニュー", message: "メニューを選択してください", preferredStyle: .actionSheet)
        let signOutAction = UIAlertAction(title: "ログアウト", style: .default) { (action) in
            //ログインの画面に戻るので
            NCMBUser.logOutInBackground { (error) in
                if error != nil {
                    print(error)
                    //ログアウト成功した場合
                } else {
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                    //画面の一番下を取得
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    //ログイン状態の保持
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
            }
        }
        
        //退会
        let deleteAction = UIAlertAction(title: "退会", style: .default) { (action) in
            //どのuserを削除するか
            let user = NCMBUser.current()
            user?.deleteInBackground({ (error) in
                if error != nil {
                    print(error)
                } else {
                    let storyboard = UIStoryboard(name: "Signin", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    //ログイン状態の保持
                    let ud = UserDefaults.standard
                    //"isLogin"がfalse、つまりログアウト状態
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
                
            })
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            //AlertControllerを閉じるので
            alertController.dismiss(animated: true, completion: nil)
        }
        
        
        alertController.addAction(signOutAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }
    
}

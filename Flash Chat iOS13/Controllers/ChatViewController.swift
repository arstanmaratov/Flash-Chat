//
//  ChatViewController.swift
//  Flash Chat iOS13
// Created by Арстан on 2/6/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import IQKeyboardManagerSwift

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore()
    var messages : [Message] = [
        Message(sender: "1@2.com", body: "Слоулекум"),
        Message(sender: "a@b.com", body: "Салам алейкум"),
        Message(sender: "1@2.com", body: " Здорова на")
    ]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessage()
        
    }
    
    func loadMessage(){
        
        db.collection(K.FStore.collectionName)
            .order(by:K.FStore.dateField)
            .addSnapshotListener{ [self] (querySnapshot,error) in
                self.messages = []
                if let e = error {
                    print("Возникла проблема с получением данных из Firestore.\(e)")
                } else {
                    if let snapchotsDocument = querySnapshot?.documents{
                        for doc in snapchotsDocument {
                            let data = doc.data()
                            if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                                let newMessage = Message(sender: messageSender, body: messageBody)
                                self.messages.append(newMessage)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let indexPath =  IndexPath(row: self.messages.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                                
                            }
                        }
                    }
                }
            }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField:messageSender,K.FStore.bodyField: messageBody,K.FStore.dateField : Date().timeIntervalSince1970]) {
                (error) in
                if let e = error{
                    print("При сохранении произошла ошибка в  Firestore\(e)")
                }else{
                    print("Сохранение прошло удачно")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
            
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
}

extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        as! MessageCell
        cell.label.text = message.body
        // Это сообщение от текущего пользователя
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
            // это сообщение от другого пользователя
        }else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        // это сообщение от другого пользователя
        return cell
    }
    //extension ChatViewController : UITableViewDelegate {
    //func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //print(indexPath.row)
    //}
    //} взаимодействие с ячейками
}

//
//  ViewController.swift
//  CombineUIKit
//
//  Created by Michael Miles on 12/11/20.
//

import UIKit
import Combine

extension Notification.Name {
    static let newMessage = Notification.Name("newMessage")
}

struct Message {
    let content: String
    let author: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var allowMessagesSwitch: UISwitch!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    @Published var canSendMessages = false
    
    private var switchSubscriber: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChain()
    }
    
    func setupChain() {
        switchSubscriber = $canSendMessages
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: sendButton)
        
        let messagePublisher = NotificationCenter.Publisher(center: .default, name: .newMessage)
            .map({notification -> String? in
                return (notification.object as? Message)?.content
            })
        
        let messageSubscriber = Subscribers.Assign(object: messageLabel, keyPath: \.text)
        messagePublisher.subscribe(messageSubscriber)
    }

    @IBAction func didSwitch(_ sender: UISwitch) {
        canSendMessages = sender.isOn
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let message = Message(content: "Hello World", author: "Self")
        NotificationCenter.default.post(name: .newMessage, object: message)
    }
}


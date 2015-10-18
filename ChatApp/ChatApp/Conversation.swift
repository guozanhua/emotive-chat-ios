//
//  Conversation.swift
//  ChatApp
//
//  Created by Rahul Madduluri on 9/27/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit

class Conversation: NSObject
{
    static var conversationPath = "conversations/"
    
    var uuid: String?
    var title: String?
    var groupConversation: Bool
    var otherUserUuids: [String]?
    var messages: [Message]?
    
    // MARK: - Initializers
    
    init(uuidList: [String])
    {
        if (uuidList.count > 1) {
            self.groupConversation = true
        }
        else {
            self.groupConversation = false
        }

        super.init()
        
        self.otherUserUuids = uuidList
    }
    
    // MARK: - Internal Methods
    
    func addUser(uuid: String)
    {
        self.otherUserUuids?.append(uuid)
    }
    
    func appendMessage(message: Message)
    {
        self.messages?.append(message)
    }
}

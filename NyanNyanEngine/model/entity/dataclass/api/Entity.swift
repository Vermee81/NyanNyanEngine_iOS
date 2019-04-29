//
//  Entity.swift
//  NyanNyanEngine
//
//  Created by Tetsuya Nishikawa on 2019/04/29.
//  Copyright © 2019 Tetsuya Nishikawa. All rights reserved.
//

import Foundation

struct Entity: Codable {
    let urls: [Url]
    let userMentions: [UserMention]
}
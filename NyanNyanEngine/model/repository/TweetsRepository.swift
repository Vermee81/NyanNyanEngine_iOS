//
//  HomeTimelineRepository.swift
//  NyanNyanEngine
//
//  Created by Tetsuya Nishikawa on 2019/05/01.
//  Copyright © 2019 Tetsuya Nishikawa. All rights reserved.
//

import Foundation
import RxSwift

protocol BaseTweetsRepository: AnyObject {
    func isLoggedIn() -> Bool
    func getHomeTimeLine() -> Observable<[Status]?>
}

class TweetsRepository: BaseTweetsRepository {
    static let shared = TweetsRepository()
    
    private let apiClient: BaseApiClient
    private let userDefaultsConnector: BaseUserDefaultsConnector
    
    private init(apiClient: BaseApiClient = ApiClient.shared,
                 userDefaultsConnector: BaseUserDefaultsConnector = UserDefaultsConnector.shared) {
        self.apiClient = apiClient
        self.userDefaultsConnector = userDefaultsConnector
    }
    
    func getHomeTimeLine() -> Observable<[Status]?> {
        guard let apiKey = PlistConnector.shared.getString(withKey: "apiKey"),
            let apiSecret = PlistConnector.shared.getString(withKey: "apiSecret"),
            let urlRequest = ApiRequestFactory(apiKey: apiKey, apiSecret: apiSecret, oauthTimeStamp: String(Int(NSDate().timeIntervalSince1970)), oauthNonce: "0000", accessTokenSecret: "kanriGamenKaraTottaSecretWoIreru").createHomeTimelineRequest() else { return Observable<[Status]?>.empty() }
        
        return self.apiClient
            .postResponse(urlRequest: urlRequest)
            .map { [unowned self] in self.toStatuses(data: $0) }
    }
    
    func isLoggedIn() -> Bool {
        return userDefaultsConnector.isRegistered(withKey: "oauth_token")
    }
    
    private func toStatuses(data: Data?) -> [Status]? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let d = data else { return nil }
        return try? decoder.decode([Status].self, from: d)
    }
}

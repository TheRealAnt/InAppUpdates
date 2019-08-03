//
//  InAppUpdates.swift
//  Reply
//
//  Created by Antonie on 2019/08/01.
//  Copyright © 2019 antonie. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

// getting data from the url
struct AppStoreApi: Decodable {
    
    let resultCount: Int
    
    //dictionary
    let results: [Result]
}

// mapping app details from the AppStore
struct Result: Decodable {
    // release notes
    let releaseNotes: String?
    
    // minimum OS version supported
    let minimumOsVersion: String?
    
    // current app version
    let version: String?
    
    // current app name
    let trackName: String?
    
    // date of the first time the app was ever released
    let releaseDate: String?
    
    // date of when the current version of the app was released
    let currentVersionReleaseDate: String?
    
    // name of who created the app
    let artistName: String?
    
    // bundled ID
    let bundleId: String?
    
    // link to open appStore for download
    let trackViewUrl: String?
}

// local app details from the info.plist
struct currentAppVersionDetails {
    let info = Bundle.main.infoDictionary
    
    var appName: String {
        if (info?["CFBundleName"] != nil){
            return info?["CFBundleName"] as! String
        }else{
            return "No app name set!"
        }
    }
    
    var versionNumber: String {
        if info?["CFBundleShortVersionString"] != nil {
            return info?["CFBundleShortVersionString"] as! String
        }else {
            return "No app version set!"
        }
    }
    
    var buildNumber: String {
        if(info?["CFBundleVersion"] != nil){
            return info?["CFBundleVersion"] as! String
        } else{
            return "no build number set!"
        }
    }
    
    var bundleId: String {
        if (info != nil){
            return Bundle.main.bundleIdentifier!
        }else{
            return "No app bundle Id set!"
        }
    }
}

class InAppUpdates {
    
    func accessAppStoreApi() {
        
        guard let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(currentAppVersionDetails().bundleId)") else { return }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            //decodes data from the appStore API for us to use
            do {
                let decodedResponse = try JSONDecoder().decode(AppStoreApi.self, from: data!)
                if (!decodedResponse.results.isEmpty) {
                    let userAppVersion = currentAppVersionDetails().versionNumber
                    let result = decodedResponse.results.first
                    // compare version numbers
                    if result?.version!.compare(userAppVersion, options: .numeric) == .orderedDescending {
                        // show app update alert view controller
                        DispatchQueue.main.async {
                            self.showAppUpdateAlert(storeLink: URL(string: (result?.trackViewUrl)!)!, newVersionNumber: String(stringLiteral: (result?.version)!), appName: String(stringLiteral: (result?.trackName)!))
                        }
                    }
                } else {
                    //error
                    print("No results found")
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    // the app update alert dialog
    func showAppUpdateAlert(storeLink: URL, newVersionNumber: String, appName: String) {
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindowLevelAlert + 1
        win.makeKeyAndVisible()
        
        let alert = UIAlertController(title: "App Update", message: "\n \(appName) v\(newVersionNumber) is now available for download", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Download", style: .default){(action:UIAlertAction!) in
            UIApplication.shared.open(URL(string: "\(storeLink)")!)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(alert, animated: true, completion: nil)
    }
}


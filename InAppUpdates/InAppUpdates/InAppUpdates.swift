//
//  InAppUpdates.swift
//  InAppUpdates
//
//  Created by Antonie on 2019/08/10.
//  Copyright © 2019 antonie. All rights reserved.
//

import Foundation
import SafariServices

// getting data from the url
struct AppStoreApi: Decodable {
    
    let resultCount: Int
    
    //dictionary
    let results: [Result]
}

// app details from the AppStore
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

public class InAppUpdates{
    private init() {}
    
    public func accessAppStoreApi() {
        
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
                    let userOSVersion = UIDevice.current.systemVersion
                    print(userOSVersion)
                    let result = decodedResponse.results.first
                    // first check user device iOS version can run the new app version
                    if (result?.minimumOsVersion?.compare(userOSVersion, options: .numeric) == .orderedAscending || result?.minimumOsVersion?.compare(userOSVersion, options: .numeric) == .orderedSame)
                    {
                        // then compare app version numbers
                        if (result?.version!.compare(userAppVersion, options: .numeric) == .orderedDescending){
                            // show app update alert view controller
                            DispatchQueue.main.async {
                                self.showAppUpdateAlert(storeLink: URL(string: (result?.trackViewUrl)!)!)
                            }
                        } else{
                            //error
                            print("No results found")
                        }
                        
                    }
                } else {
                    #if DEBUG
                    print("iOS version is too low for an update")
                    #endif
                }
            }
            catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    // the app update alert dialog
    public func showAppUpdateAlert(storeLink: URL) {
        let appName = currentAppVersionDetails().appName
        let alert = UIAlertController(title: "App Update", message: "A newer version of \(appName) is available for download.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Download", style: .default){(action:UIAlertAction!) in
            UIApplication.shared.open(URL(string: "\(storeLink)")!)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.showOnTop()
    }
}

public extension UIAlertController {
    func showOnTop() {
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindowLevelAlert + 1
        win.makeKeyAndVisible()
        vc.present(self, animated: true, completion: nil)
    }
}

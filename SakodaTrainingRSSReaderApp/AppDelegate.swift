//
//  AppDelegate.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/06/10.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let userDefaults = UserDefaultsManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// UserDefaultsに保存されている背景色(ダークモード・ライトモード)の取り出しの処理を記述
extension AppDelegate {
    func loadAndApplyAppearance() {
        do {
            if let style = try userDefaults.loadDarkModePreference() {
                setAppAppearance(to: style)
            } else {
                // スタイルが存在しないデフォルトの背景色
                setAppAppearance(to: .light)
            }
            
        } catch UserDefaultsError.styleKeyNotFound {
            print("UserDefaultsにスタイルキーが見つかりませんでした。")
            setAppAppearance(to: .light)
        } catch UserDefaultsError.invalidStyleValue {
            print("無効なスタイル値が見つかりました。")
            setAppAppearance(to: .light)
        } catch {
            print("その他のエラーが発生しました: \(error)")
            setAppAppearance(to: .light)
        }
    }
    
    func setAppAppearance(to style: UIUserInterfaceStyle) {
        // UIWindowSceneを取得
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return print("💫UIWindowScene is nil.") }
        
        // すべてのウィンドウに対して外観を適用
        windowScene.windows.forEach { window in
            window.overrideUserInterfaceStyle = style
        }
    }
}


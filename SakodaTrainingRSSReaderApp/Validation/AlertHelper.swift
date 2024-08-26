//
//  AlertHelper.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/08/18.
//

import Foundation
import FirebaseAuth
import UIKit


struct AlertHelper {
    
    static func showAlert(
        on viewController: UIViewController,
        message: String
    ){
        let alert = UIAlertController(
            title: "エラー",
            message: message,
            preferredStyle: .alert
        )
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        viewController.present(alert, animated: true)
    }
    
    static func handleAuthError(_ error: AuthErrorCode) -> String {
        switch error.code {
        case .invalidCustomToken:
            return "無効なカスタムトークンです。再試行してください。"
        case .customTokenMismatch:
            return "トークンが一致しません。再試行してください。"
        case .invalidCredential:
            return "無効な認証情報です。再確認してください。"
        case .userDisabled:
            return "このユーザーアカウントは無効です。管理者にお問い合わせください。"
        case .operationNotAllowed:
            return "この操作は許可されていません。"
        case .emailAlreadyInUse:
            return "このメールアドレスは既に使用されています。"
        case .invalidEmail:
            return "無効なメールアドレスです。"
        case .wrongPassword:
            return "パスワードが間違っています。再試行してください。"
        case .tooManyRequests:
            return "ログインに何度も失敗したため、このアカウントへのアクセスは一時的に無効になっています。"
        case .userNotFound:
            return "ユーザーが見つかりませんでした。"
        case .accountExistsWithDifferentCredential:
            return "別の認証情報で既にアカウントが存在しています。"
        case .requiresRecentLogin:
            return "最近のログインが必要です。再度ログインしてください。"
        case .providerAlreadyLinked:
            return "この認証プロバイダは既にリンクされています。"
        case .noSuchProvider:
            return "存在しない認証プロバイダです。"
        case .invalidUserToken:
            return "無効なユーザートークンです。再ログインしてください。"
        case .networkError:
            return "ネットワークエラーが発生しました。再試行してください。"
        case .userTokenExpired:
            return "ユーザートークンが期限切れです。再ログインしてください。"
        case .invalidAPIKey:
            return "無効なAPIキーです。設定を確認してください。"
        case .userMismatch:
            return "ユーザーが一致しません。正しいアカウントでログインしてください。"
        case .credentialAlreadyInUse:
            return "この認証情報は既に使用されています。"
        case .weakPassword:
            return "パスワードが弱すぎます。より強力なパスワードを選んでください。"
        case .appNotAuthorized:
            return "このアプリは認証されていません。設定を確認してください。"
        case .expiredActionCode:
            return "アクションコードが期限切れです。"
        case .invalidActionCode:
            return "無効なアクションコードです。"
        case .invalidMessagePayload:
            return "無効なメッセージペイロードです。"
        case .invalidSender:
            return "無効な送信者です。"
        case .invalidRecipientEmail:
            return "無効な受信者のメールアドレスです。"
        case .missingEmail:
            return "メールアドレスが欠落しています。"
        case .missingIosBundleID:
            return "iOSバンドルIDが欠落しています。"
        case .missingAndroidPackageName:
            return "Androidパッケージ名が欠落しています。"
        case .unauthorizedDomain:
            return "許可されていないドメインです。"
        case .invalidContinueURI:
            return "無効なContinue URIです。"
        case .missingContinueURI:
            return "Continue URIが欠落しています。"
        case .missingPhoneNumber:
            return "電話番号が欠落しています。"
        case .invalidPhoneNumber:
            return "無効な電話番号です。"
        case .missingVerificationCode:
            return "認証コードが欠落しています。"
        case .invalidVerificationCode:
            return "無効な認証コードです。"
        case .missingVerificationID:
            return "認証IDが欠落しています。"
        case .invalidVerificationID:
            return "無効な認証IDです。"
        case .missingAppCredential:
            return "アプリの認証情報が欠落しています。"
        case .invalidAppCredential:
            return "無効なアプリの認証情報です。"
        case .sessionExpired:
            return "セッションが期限切れです。再ログインしてください。"
        case .quotaExceeded:
            return "クオータが超過しました。"
        case .missingAppToken:
            return "アプリのトークンが欠落しています。"
        case .notificationNotForwarded:
            return "通知が転送されませんでした。"
        case .appNotVerified:
            return "アプリが検証されていません。"
        case .captchaCheckFailed:
            return "CAPTCHAチェックに失敗しました。"
        case .webContextAlreadyPresented:
            return "Webコンテキストは既に表示されています。"
        case .webContextCancelled:
            return "Webコンテキストがキャンセルされました。"
        case .appVerificationUserInteractionFailure:
            return "アプリ検証中にユーザーの操作に失敗しました。"
        case .invalidClientID:
            return "無効なクライアントIDです。"
        case .webNetworkRequestFailed:
            return "Webネットワークリクエストが失敗しました。"
        case .webInternalError:
            return "Web内部エラーが発生しました。"
        case .webSignInUserInteractionFailure:
            return "Webサインイン中のユーザー操作に失敗しました。"
        case .localPlayerNotAuthenticated:
            return "ローカルプレイヤーが認証されていません。"
        case .nullUser:
            return "ユーザーがnullです。"
        case .dynamicLinkNotActivated:
            return "ダイナミックリンクが有効化されていません。"
        case .invalidProviderID:
            return "無効なプロバイダIDです。"
        case .tenantIDMismatch:
            return "テナントIDが一致しません。"
        case .unsupportedTenantOperation:
            return "サポートされていないテナント操作です。"
        case .invalidDynamicLinkDomain:
            return "無効なダイナミックリンクドメインです。"
        case .rejectedCredential:
            return "認証情報が拒否されました。"
        case .gameKitNotLinked:
            return "GameKitがリンクされていません。"
        case .secondFactorRequired:
            return "二要素認証が必要です。"
        case .missingMultiFactorSession:
            return "多要素認証セッションが欠落しています。"
        case .missingMultiFactorInfo:
            return "多要素認証情報が欠落しています。"
        case .invalidMultiFactorSession:
            return "無効な多要素認証セッションです。"
        case .multiFactorInfoNotFound:
            return "多要素認証情報が見つかりませんでした。"
        case .adminRestrictedOperation:
            return "管理者によって制限された操作です。"
        case .unverifiedEmail:
            return "メールアドレスが未確認です。"
        case .secondFactorAlreadyEnrolled:
            return "既に二要素認証が登録されています。"
        case .maximumSecondFactorCountExceeded:
            return "二要素認証の最大登録数を超えました。"
        case .unsupportedFirstFactor:
            return "サポートされていない第一要素です。"
        case .emailChangeNeedsVerification:
            return "メールアドレスの変更には確認が必要です。"
        case .missingClientIdentifier:
            return "クライアント識別子が欠落しています。"
        case .missingOrInvalidNonce:
            return "ノンスが欠落しているか無効です。"
        case .blockingCloudFunctionError:
            return "クラウド関数のエラーが発生しました。"
        case .recaptchaNotEnabled:
            return "reCAPTCHAが有効になっていません。"
        case .missingRecaptchaToken:
            return "reCAPTCHAトークンが欠落しています。"
        case .invalidRecaptchaToken:
            return "無効なreCAPTCHAトークンです。"
        case .invalidRecaptchaAction:
            return "無効なreCAPTCHAアクションです。"
        case .missingClientType:
            return "クライアントタイプが欠落しています。"
        case .missingRecaptchaVersion:
            return "reCAPTCHAバージョンが欠落しています。"
        case .invalidRecaptchaVersion:
            return "無効なreCAPTCHAバージョンです。"
        case .invalidReqType:
            return "無効なリクエストタイプです。"
        case .recaptchaSDKNotLinked:
            return "reCAPTCHA SDKがリンクされていません。"
        case .keychainError:
            return "キーチェーンエラーが発生しました。"
        case .internalError:
            return "内部エラーが発生しました。"
        case .malformedJWT:
            return "JWTが不正な形式です。"
        @unknown default:
            return "未知のエラーが発生しました。"
        }
    }
    
}

import Flutter
import UIKit
import BranchSDK
import FBSDKCoreKit

class SceneDelegate: FlutterSceneDelegate {

    override func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        super.scene(scene, willConnectTo: session, options: connectionOptions)

        for userActivity in connectionOptions.userActivities {
            Branch.getInstance().continue(userActivity)
        }

        for context in connectionOptions.urlContexts {
            Branch.getInstance().application(UIApplication.shared, open: context.url, options: [:])
            ApplicationDelegate.shared.application(
                UIApplication.shared,
                open: context.url,
                sourceApplication: context.options.sourceApplication,
                annotation: context.options.annotation
            )
        }
    }

    override func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        super.scene(scene, continue: userActivity)
        Branch.getInstance().continue(userActivity)
    }

    override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        super.scene(scene, openURLContexts: URLContexts)
        for context in URLContexts {
            Branch.getInstance().application(UIApplication.shared, open: context.url, options: [:])
            ApplicationDelegate.shared.application(
                UIApplication.shared,
                open: context.url,
                sourceApplication: context.options.sourceApplication,
                annotation: context.options.annotation
            )
        }
    }
}

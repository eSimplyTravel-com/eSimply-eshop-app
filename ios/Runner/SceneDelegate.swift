import Flutter
import UIKit
import FBSDKCoreKit

class SceneDelegate: FlutterSceneDelegate {

    // Branch used to be handed every incoming user activity and URL here. The SDK
    // is gone (it was never configured — empty branch_key, disabled in every
    // environment), so the only forwarding left is Facebook's, for the OAuth
    // callback. Universal links reach Dart through `super`, which is what
    // FlutterSceneDelegate passes to the app_links plugin — do not drop those
    // super calls, they are the deep-link path.
    override func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        super.scene(scene, willConnectTo: session, options: connectionOptions)

        for context in connectionOptions.urlContexts {
            ApplicationDelegate.shared.application(
                UIApplication.shared,
                open: context.url,
                sourceApplication: context.options.sourceApplication,
                annotation: context.options.annotation
            )
        }
    }

    override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        super.scene(scene, openURLContexts: URLContexts)
        for context in URLContexts {
            ApplicationDelegate.shared.application(
                UIApplication.shared,
                open: context.url,
                sourceApplication: context.options.sourceApplication,
                annotation: context.options.annotation
            )
        }
    }
}

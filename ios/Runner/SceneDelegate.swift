import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {

    // Branch and the Meta SDK both used to be handed every incoming URL here.
    // Both are gone. Nothing native forwards URLs any more: the Supabase OAuth
    // callback (iosupabaseesimply://) and universal links both reach Dart
    // through `super`, which is what FlutterSceneDelegate passes to the
    // app_links plugin — do not drop those super calls, they are the whole
    // deep-link and social-login-callback path.
    override func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        super.scene(scene, willConnectTo: session, options: connectionOptions)
    }

    override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        super.scene(scene, openURLContexts: URLContexts)
    }
}

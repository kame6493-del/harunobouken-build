import UIKit
import Capacitor

// ハルの冒険のゲーム画面。Capacitor の画面に、遊んでいる間の端末の振る舞いを足す。
// - 画面の下のホームバーを隠し、画面の端のスワイプはゲームの操作を先に受ける(ジャンプ・移動の指で閉じない)
// - コントローラーで遊ぶ間は画面に触れないので、表示中は自動ロックで暗くしない
class HaruGameViewController: CAPBridgeViewController {
    override var prefersHomeIndicatorAutoHidden: Bool { true }

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge { .all }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        setNeedsUpdateOfHomeIndicatorAutoHidden()
        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = HaruGameViewController()
        window?.makeKeyAndVisible()

        SceneDelegateProxy.shared.scene(scene, willConnectTo: session, options: connectionOptions)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        SceneDelegateProxy.shared.scene(scene, openURLContexts: URLContexts)
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        SceneDelegateProxy.shared.scene(scene, continue: userActivity)
    }

    // ほかのアプリへ移ったら自動ロックを元に戻し、戻ってきたらまた止める
    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.isIdleTimerDisabled = true
    }

    func sceneWillResignActive(_ scene: UIScene) {
        UIApplication.shared.isIdleTimerDisabled = false
    }
}

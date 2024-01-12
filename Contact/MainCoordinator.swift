import Foundation
import UIKit

final class MainCoordinator {
    func moveToContact() {
        let vc = ContactViewController()
    }
    private func makeMain() -> UIViewController {
        let navigation = MainNavigation  {
            self.moveToContact()
            print("Navigation")
        }
        return ViewController(/*navigation: navigation*/)
    }
}

import UIKit
import SnapKit

struct MainNavigation {
    let openContact: (() -> Void)
}
class ViewController: UIViewController {
//    let navigation: MainNavigation
//    init(navigation: MainNavigation) {
//        self.navigation = navigation
//        super.init(nibName: nil, bundle: nil)
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    private let clickButton = UIButton().apply {
        $0.setTitle("Click me", for: .normal)
        $0.addTarget(self, action: #selector(openPresent), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        setupViews()
        setupConstraints()
    }
    
    @objc func openPresent() {
        print("clicked")
        let vc = ContactViewController()
        self.present(vc, animated: true) {
            print("Open Contact present")
        }
//        navigation.openContact()
    }
}

// MARK: - setupViews, setupConstaints
private extension ViewController {
    func setupViews(){
        view.addSubview(clickButton)
    }
    
    func setupConstraints() {
        clickButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

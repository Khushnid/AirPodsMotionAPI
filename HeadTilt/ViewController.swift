import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let SPEED_MULTIPLIER: Double = 12
    let manager = CMHeadphoneMotionManager()
    
    let cursorImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "cursor")
        return image
    }()
    
    let statusTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .black
        return title
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupAirPods()
    }
    
    private func setupConstraints() {
        view.addSubview(statusTitle)
        view.addSubview(cursorImage)
        
        NSLayoutConstraint.activate([
            statusTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            statusTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         
            cursorImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cursorImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cursorImage.heightAnchor.constraint(equalToConstant: 20),
            cursorImage.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupAirPods() {
        manager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: { [self] deviceMotion, _ -> Void in
            if let motion = deviceMotion {
                let pitch = degrees(motion.attitude.pitch)
                let yaw = degrees(motion.attitude.yaw)
                let xCoordinate = view.center.x - yaw * SPEED_MULTIPLIER
                let yCoordinate = view.center.y - pitch * SPEED_MULTIPLIER + UIScreen.main.bounds.width / 3
                cursorImage.center = CGPoint(x: xCoordinate, y: yCoordinate)
            }
        })
    }
    
    func degrees(_ radians: Double) -> Double {
        return 180 / .pi * radians
    }
}

extension ViewController: CMHeadphoneMotionManagerDelegate {
   func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        view.backgroundColor = .white
        statusTitle.text = "Connected"
    }
    
    func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        view.backgroundColor = .red.withAlphaComponent(0.6)
        statusTitle.text = "Disconnected"
    }
}

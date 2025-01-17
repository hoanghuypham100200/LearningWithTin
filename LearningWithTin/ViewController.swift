import UIKit
import GoogleMobileAds

class RewardedAdViewController: UIViewController {

    private var rewardedAd: GADRewardedAd?
    var money = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Load the rewarded ad
        loadRewardedAd()
        
        // Add a button to trigger the rewarded ad
        let showAdButton = UIButton(type: .system)
        showAdButton.setTitle("Show Rewarded Ad", for: .normal)
        showAdButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        showAdButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        showAdButton.center = view.center
        showAdButton.addTarget(self, action: #selector(showRewardedAdButtonTapped), for: .touchUpInside)
        view.addSubview(showAdButton)
    }

    private func loadRewardedAd() {
        let testAdUnitID = "ca-app-pub-3940256099942544/1712485313"
        let request = GADRequest()

        GADRewardedAd.load(withAdUnitID: testAdUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad: \(error.localizedDescription)")
                return
            }
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
        }
    }

    @objc private func showRewardedAdButtonTapped() {
        guard let rewardedAd = rewardedAd else {
            print("Rewarded ad is not ready yet.")
            return
        }

        rewardedAd.present(fromRootViewController: self) {
            let reward = rewardedAd.adReward
            print("User earned reward: \(reward.amount) \(reward.type)")
            // Grant the reward to the user here (e.g., coins, extra lives)
        }
    }
}

// MARK: - GADFullScreenContentDelegate
extension RewardedAdViewController: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad dismissed.")
        // Reload the ad after it is dismissed
        loadRewardedAd()
    }

    func adDidFailToPresentFullScreenContent(_ ad: GADFullScreenPresentingAd, withError error: Error) {
        print("Ad failed to present: \(error.localizedDescription)")
    }

   
}


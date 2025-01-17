import UIKit
import SnapKit
import GoogleMobileAds
class PokemonViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate, GADFullScreenContentDelegate {

    private var bannerView: GADBannerView!
    private var interstitial: GADInterstitialAd?

    private let tableView = UITableView()
    private let label = UILabel()
    private let viewModel = PokemonViewModel()
    private let errorView  = UIView()
    private let errorLabel = UILabel()
    private let errorImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupconstrains()
        viewModel.fetchPokemons()
        viewModel.reloadTableView = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.updateView = { [weak self] in
            self?.updateUI()
        }
        bannerView.load(GADRequest())
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Your custom code
        adss()

    }
    private func adss(){
        Task {
              do {
                interstitial = try await GADInterstitialAd.load(
                  withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: GADRequest())
                interstitial?.fullScreenContentDelegate = self
              } catch {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
              }
            }
    }

    private func setupUI() {
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        
        label.text = "POKEMON"
        label.font = UIFont.systemFont(ofSize: 30,weight: .bold)
        label.textColor = .systemPink
        label.textAlignment = .center
        
        errorView.isHidden = true
        errorImageView.image = UIImage.image
        errorLabel.text = "We are under maintenance"
        errorLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        bannerView.rootViewController = self
        bannerView.delegate = self
    }
    private func setupconstrains() {
        view.addSubview(tableView)
        view.addSubview(label)
        view.addSubview(errorView)
        view.addSubview(bannerView)
        errorView.addSubview(errorLabel)
        errorView.addSubview(errorImageView)
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(bannerView.snp.top)
        }
        bannerView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-15)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(tableView.snp.bottom)
            $0.height.equalTo(50)
        }
        errorView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        errorImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(180)
        }
        errorLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(errorImageView.snp.bottom).offset(10)
        }
    }
    private func updateUI() {
        tableView.isHidden = true
        errorView.isHidden = false
        label.isHidden = true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = viewModel.pokemonName(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemonDetailVC = PokemonDetailViewController()
        pokemonDetailVC.pokemonId = indexPath.row + 1
        navigationController?.pushViewController(pokemonDetailVC, animated: true)
        if (interstitial != nil) {
            interstitial!.present(fromRootViewController: self)
        }
        else {
            print("errrrror")
        }
    }
    
}

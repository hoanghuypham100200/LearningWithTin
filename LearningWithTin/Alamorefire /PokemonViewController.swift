import UIKit
import SnapKit

class PokemonViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
        
    }
    private func setupconstrains() {
        view.addSubview(tableView)
        view.addSubview(label)
        view.addSubview(errorView)
        errorView.addSubview(errorLabel)
        errorView.addSubview(errorImageView)
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
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
    }
    
}

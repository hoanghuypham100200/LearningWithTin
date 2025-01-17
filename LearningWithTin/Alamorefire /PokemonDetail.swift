//
//  PokemonDetail.swift
//  LearningWithTin
//
//  Created by Huy on 10/1/25.
//
import UIKit
import SnapKit
import Kingfisher
class PokemonDetailViewController: UIViewController {
    var pokemonId: Int?
    
    private let nameLabel = UILabel()
   
    private let abilitiesLabel = UILabel()
    private let spriteImageView = UIImageView()
    private let typesLabel = UILabel()
    private let pokedexLabel = UILabel()
    private let viewModel = PokemonViewModel()
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupRx()


    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            // Cập nhật giao diện mỗi lần view sắp xuất hiện
          
    }
    private func setupRx() {
        if let pokemonId = pokemonId {
            viewModel.fetchPokemonById(id: pokemonId)
        }
        viewModel.updateView = { [weak self] in
            self?.updateUI()
        }
    }

    private func setupUI() {
        view.backgroundColor = .white

        nameLabel.font = UIFont.systemFont(ofSize:25,weight: .bold )
        nameLabel.textColor = .systemBlue
        
        pokedexLabel.text = "Pokédex data"
        pokedexLabel.textColor = .black
        pokedexLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        abilitiesLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        abilitiesLabel.textColor = .brown
        
        typesLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        typesLabel.textColor = .brown
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
    }
    private func setupConstraints() {
        view.addSubview(spriteImageView)
        view.addSubview(nameLabel)
        view.addSubview(pokedexLabel)
        view.addSubview(abilitiesLabel)
        view.addSubview(typesLabel)
        view.addSubview(stackView)
        
        spriteImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.width.equalTo(200)
            $0.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(spriteImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        pokedexLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        abilitiesLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(pokedexLabel.snp.bottom).offset(10)
        }
        typesLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(abilitiesLabel.snp.bottom).offset(10)
        }
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(typesLabel.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(16)

        }
        
    }
    
    private func setupSliders(stats:[(name: String, value: Int)]) {
        for stat in stats {
            let container = UIView()
            let label = UILabel()
            let slider = UISlider()
            
            // Configure label
            label.text = "\(stat.name.capitalized): \(stat.value)"
            label.font = UIFont.systemFont(ofSize: 16)
            container.addSubview(label)
            
            // Configure slider
            slider.minimumValue = 0
            slider.maximumValue = 150
            slider.value = Float(stat.value)
            slider.isEnabled = false // Make slider read-only
            slider.setThumbImage(UIImage(), for: .normal)
            slider.transform = CGAffineTransform(scaleX: 1, y: 3) // Set custom height

            container.addSubview(slider)
            
            // Layout label
            
            label.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview()
                
            }
            slider.snp.makeConstraints {
                $0.top.equalTo(label.snp.bottom).offset(5)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().inset(5)

            }
            stackView.addArrangedSubview(container)
        }
    }

    private func updateUI() {
        let stats = viewModel.getStats()
        setupSliders(stats: stats)
            nameLabel.text = viewModel.getPokemonName()
            abilitiesLabel.text = viewModel.getAbilities()
            typesLabel.text = viewModel.getTypes()
            // Fetch the sprite and set it to the image view
        if let spriteURL = viewModel.getSpriteURL(), let url = URL(string: spriteURL) {
                   spriteImageView.kf.setImage(with: url)
        }
    }
}

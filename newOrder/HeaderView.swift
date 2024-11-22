//
//  HeaderView.swift
//  newOrder
//
//  Created by Александр Белый on 13.11.2024.
//

import UIKit

    class HeaderView: UIView {
        
        
        protocol HeaderViewDelegate: AnyObject {
            func promocodeButtonTapped()
        }
        
        weak var delegate: HeaderViewDelegate?
       
        let mobileDivider = UIView()
        let titleDesk = UIView()
        let titleDeskText = UILabel()
        let oneProductOnePromo = UILabel()
        let buttonPromocode = UIButton(type: .system)
        let imageView = UIView()
        let image = UIImageView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupViews()
            setupConstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupViews() {
            // Настроим mobileDivider
            mobileDivider.layer.shadowColor = UIColor.gray.cgColor
            mobileDivider.layer.shadowOpacity = 0.1
            mobileDivider.layer.shadowOffset = CGSize(width: 0, height: 2)
            mobileDivider.layer.shadowRadius = 3
            mobileDivider.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
            mobileDivider.translatesAutoresizingMaskIntoConstraints = false
            addSubview(mobileDivider)
            
            // Настроим titleDesk и titleDeskText
            titleDesk.translatesAutoresizingMaskIntoConstraints = false
            addSubview(titleDesk)
            
            titleDeskText.text = "Промокоды"
            titleDeskText.textColor = .black
            titleDeskText.font = .systemFont(ofSize: 24)
            titleDeskText.numberOfLines = 0
            titleDeskText.lineBreakMode = .byWordWrapping
            titleDeskText.translatesAutoresizingMaskIntoConstraints = false
            titleDesk.addSubview(titleDeskText)
            
            // Настроим oneProductOnePromo
            oneProductOnePromo.text = "На один товар можно применить только один промокод"
            oneProductOnePromo.textColor = .gray
            oneProductOnePromo.font = .systemFont(ofSize: 14)
            oneProductOnePromo.numberOfLines = 0
            oneProductOnePromo.lineBreakMode = .byWordWrapping
            oneProductOnePromo.translatesAutoresizingMaskIntoConstraints = false
            addSubview(oneProductOnePromo)
            
            // Настроим buttonPromocode
            buttonPromocode.backgroundColor = UIColor(red: 255/255, green: 70/255, blue: 17/255, alpha: 0.1) // Цвет кнопки
            buttonPromocode.setTitle("Применить промокод", for: .normal)
            buttonPromocode.setTitleColor(UIColor(red: 255/255, green: 69/255, blue: 0/255, alpha: 1), for: .normal)
            buttonPromocode.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            buttonPromocode.layer.cornerRadius = 12
            buttonPromocode.translatesAutoresizingMaskIntoConstraints = false
            buttonPromocode.addTarget(self, action: #selector(buttonPromocodeTapped(_:)), for: .touchUpInside)
            addSubview(buttonPromocode)
            
            // Настроим imageView и image
            imageView.translatesAutoresizingMaskIntoConstraints = false
            buttonPromocode.addSubview(imageView)
            
            image.image = UIImage(named: "shape") // Имя изображения для image
            image.contentMode = .scaleAspectFill
            image.translatesAutoresizingMaskIntoConstraints = false
            imageView.addSubview(image)
            
        }
        
          @objc private func buttonPromocodeTapped(_ sender: UIButton) {
              delegate?.promocodeButtonTapped()
              
        }
        
        private func setupConstraints() {
            
            
            // Constraints для mobileDivider
            mobileDivider.snp.makeConstraints { make in
                make.top.equalTo(self.snp.top)
                make.left.right.equalTo(self)
                make.height.equalTo(16)
            }
            
            // Constraints для titleDesk и titleDeskText
            NSLayoutConstraint.activate([
                titleDesk.topAnchor.constraint(equalTo: mobileDivider.bottomAnchor, constant: 24),
                titleDesk.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
                titleDesk.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
                titleDesk.heightAnchor.constraint(equalToConstant: 82),
                
                titleDeskText.topAnchor.constraint(equalTo: titleDesk.topAnchor, constant: 1),
                titleDeskText.leftAnchor.constraint(equalTo: titleDesk.leftAnchor, constant: 1),
                titleDeskText.rightAnchor.constraint(equalTo: titleDesk.rightAnchor, constant: -1)
            ])
            
            // Constraints для oneProductOnePromo
            oneProductOnePromo.snp.makeConstraints { make in
                make.top.equalTo(titleDeskText.snp.bottom).offset(10)
                make.left.equalTo(titleDesk)
                make.right.equalTo(titleDesk)
            }
            
            // Constraints для buttonPromocode
            buttonPromocode.snp.makeConstraints { make in
                make.top.equalTo(titleDesk.snp.bottom).offset(16)
                make.left.equalTo(titleDesk)
                make.right.equalTo(titleDesk)
                make.bottom.equalTo(self.snp.bottom)
            }
            
            // Constraints для imageView
            imageView.snp.makeConstraints { make in
                make.top.equalTo(buttonPromocode.snp.top).offset(19)
                make.left.equalTo(buttonPromocode.snp.left).offset(75)
                make.width.equalTo(20)
                make.height.equalTo(16)
            }
        }
        
        
    }



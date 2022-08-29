//
//  AccountsViewController.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 7/30/22.
//
import UIKit
import Foundation


class AccountsViewController: UIViewController {
    var scrollView: UIScrollView!
    var contentView: UIView!
    var allMyAccountsButton: UIView!
    var head: AccountHead!
    var shareQRTitleLabel: UILabel!
    var overlayLayer: CALayer?
    
    deinit { log_deinit(Self.self) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        setupScrollView()
        setupViews()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView = UIView()
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.equalTo(scrollView.frameLayoutGuide).priority(250)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
    }
    
    private func setupViews() {
        let accountHead = AccountHead()
        accountHead.directionalLayoutMargins = NSDirectionalEdgeInsets(horizontal: 20, vertical: 0)
        head = accountHead
        
        scrollView.addSubview(head)
        
        head.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView)
            make.top.equalTo(contentView)
        }
        
        
        setFields()
        setButtons()
    }
   
    @objc func showTransfer() {
        print("show transfer")
    }
    
    private func setFields() {
        let horizontalPadding = 15
        let verticalPadding = 15
        
        // MARK: BALANCE
        let accountBalanceTitleLabel = UILabel()
        accountBalanceTitleLabel.text = "Balance"
        accountBalanceTitleLabel.numberOfLines = 1
        accountBalanceTitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        accountBalanceTitleLabel.textColor = .white
        
        scrollView.addSubview(accountBalanceTitleLabel)
        accountBalanceTitleLabel.doesNotWantToGrow(.defaultHigh, for: .horizontal)
        
        accountBalanceTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(horizontalPadding)
            make.top.equalTo(head.snp.bottom).offset(verticalPadding)
        }
        
        let accountBalanceLabel = UILabel()
        accountBalanceLabel.text = "11,70 TL"
        accountBalanceLabel.numberOfLines = 1
        accountBalanceLabel.font = .systemFont(ofSize: 16, weight: .bold)
        accountBalanceLabel.textColor = .white
        accountBalanceLabel.textAlignment = .right
        
        scrollView.addSubview(accountBalanceLabel)
        accountBalanceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-horizontalPadding)
            make.leading.equalTo(accountBalanceTitleLabel.snp.trailing)
            make.top.equalTo(head.snp.bottom).offset(verticalPadding)
        }
        
        // MARK: IBAN
        let accountIbanNumberTitleLabel = UILabel()
        accountIbanNumberTitleLabel.text = "IBAN"
        accountIbanNumberTitleLabel.numberOfLines = 1
        accountIbanNumberTitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        accountIbanNumberTitleLabel.textColor = .white
        // accountIbanNumberTitleLabel.backgroundColor = .green
        
        scrollView.addSubview(accountIbanNumberTitleLabel)
        accountIbanNumberTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        accountIbanNumberTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(horizontalPadding)
            make.top.equalTo(accountBalanceTitleLabel.snp.bottom).offset(verticalPadding)
        }
        
        let accountIbanNumberLabel = UILabel()
        accountIbanNumberLabel.text = "TR11 1111 1111 1111 1111 1111 11"
        accountIbanNumberLabel.numberOfLines = 1
        accountIbanNumberLabel.font = .systemFont(ofSize: 16, weight: .bold)
        accountIbanNumberLabel.textColor = .white
        // accountIbanNumberLabel.backgroundColor = .red
        accountIbanNumberLabel.textAlignment = .right
        
        scrollView.addSubview(accountIbanNumberLabel)
        accountIbanNumberLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-horizontalPadding)
            make.leading.equalTo(accountIbanNumberTitleLabel.snp.trailing)
            make.top.equalTo(accountBalanceLabel.snp.bottom).offset(verticalPadding)
        }
        
        // MARK: SHARE QR
        shareQRTitleLabel = UILabel()
        shareQRTitleLabel.text = "Share Qr"
        shareQRTitleLabel.numberOfLines = 1
        shareQRTitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        shareQRTitleLabel.textColor = .white
        scrollView.addSubview(shareQRTitleLabel)
        shareQRTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        shareQRTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(horizontalPadding)
            make.top.equalTo(accountIbanNumberTitleLabel.snp.bottom).offset(verticalPadding)
        }
        
        let shareQRImage = UIImage(systemName: "square.and.arrow.up")
        let shareQRImageView = UIImageView(image: shareQRImage)
        shareQRImageView.tintColor = .white
        
        scrollView.addSubview(shareQRImageView)

        shareQRImageView.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-horizontalPadding)
            make.bottom.equalTo(shareQRTitleLabel)
            make.top.equalTo(accountIbanNumberTitleLabel.snp.bottom).offset(verticalPadding)
        }
    }
    
    
    private func setButtons() {
        let font: UIFont = .systemFont(ofSize: 13, weight: .semibold)
        let contentInsets = UIEdgeInsets(top: 8, left: 18, bottom: 8, right: 18)
        let backgroundColor: UIColor = .red
        let borderRadius: CGFloat = 15
        
        let moneyTransferButton = UIButton()
        moneyTransferButton.backgroundColor = backgroundColor
        moneyTransferButton.layer.cornerRadius = borderRadius
        moneyTransferButton.setTitle("Money Transfer", for: .normal)
        moneyTransferButton.contentEdgeInsets = contentInsets
        moneyTransferButton.titleLabel?.font = font
        moneyTransferButton.addTarget(self, action: #selector(showTransfer), for: .touchUpInside)
        
        let accountActivitiesButton = UIButton()
        accountActivitiesButton.backgroundColor = backgroundColor
        accountActivitiesButton.layer.cornerRadius = borderRadius
        accountActivitiesButton.setTitle("Account Activities", for: .normal)
        accountActivitiesButton.contentEdgeInsets =  contentInsets
        accountActivitiesButton.titleLabel?.font = font
        accountActivitiesButton.addTarget(self, action: #selector(showTransfer), for: .touchUpInside)
        
        let buttonStack = UIStackView(arrangedSubviews: [moneyTransferButton, accountActivitiesButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 15
        buttonStack.distribution = .fillEqually
        
        scrollView.addSubview(buttonStack)
   
        buttonStack.snp.makeConstraints { make in
            let horizontalPadding = 15
            make.top.equalTo(shareQRTitleLabel.snp.bottom).offset(horizontalPadding)
            make.bottom.equalTo(contentView.snp.bottomMargin)
            make.width.equalTo(contentView.snp.width)
                .offset(-2 * horizontalPadding)
                .priority(999) // low priority
            make.width.lessThanOrEqualTo(600)
            make.centerX.equalToSuperview()
        }
    }
    
    
    @objc func backTo() {
        print("backto")
    }
}

// MARK: ScrollView delegate
extension AccountsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y
        head.transform = CGAffineTransform(translationX: 0, y: min(offset, 0))
    }
}

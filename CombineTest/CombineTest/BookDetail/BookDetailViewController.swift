//
//  BookDetailViewController.swift
//  CombineTest
//
//  Created by Chung Wussup on 5/11/24.
//

import UIKit
import SnapKit
/*
 authors
 contents
 datetime
 isbn
 price
 publisher
 sale_price
 status
 thumbnail
 title
 tarnslators
 url
 */

class BookDetailViewController: UIViewController {
    private var scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    private var dataStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.spacing = 10
        stv.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return stv
    }()
    
    private var bookImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private var bookTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    private var publisherLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    private var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    var viewModel: BookDetailViewModel
    
    init(viewModel: BookDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
    }
    
    private func bindUI() {
        
        self.bookImageView.image = viewModel.bookImage != nil ? viewModel.bookImage : nil
        self.bookTitleLabel.text = viewModel.book.title
        
        var authors: String = "저자: "
        for (index, author) in viewModel.book.authors.enumerated() {
            authors += author
            if index < viewModel.book.authors.count - 1 {
                 authors += ", "
             }
        }
        
        self.authorLabel.text = authors
        
        self.dateLabel.text = "출판일: \(viewModel.book.dateString)"
        self.contentLabel.text = viewModel.book.contents
        self.publisherLabel.text = "출판사: \(viewModel.book.publisher)"
        
        let attributedString = NSMutableAttributedString(string: "가격: \(viewModel.book.commaSalePrice) \(viewModel.book.commaPrice)")

        // 가격에 취소선 추가 및 회색으로 변경
        let priceRange = (attributedString.string as NSString).range(of: viewModel.book.commaPrice)
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                       value: NSNumber(value: NSUnderlineStyle.single.rawValue),
                                       range: priceRange)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                       value: UIColor.gray,
                                       range: priceRange)

        // 판매 가격을 볼드체 및 18포인트로 변경
        let salePriceRange = (attributedString.string as NSString).range(of: viewModel.book.commaSalePrice)
        attributedString.addAttribute(NSAttributedString.Key.font,
                                       value: UIFont.boldSystemFont(ofSize: 18),
                                       range: salePriceRange)
        // 가격을 12포인트로 변경
        attributedString.addAttribute(NSAttributedString.Key.font,
                                       value: UIFont.systemFont(ofSize: 12),
                                       range: priceRange)



        self.priceLabel.attributedText = attributedString
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.dataStackView)
        
        scrollView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        dataStackView.snp.makeConstraints {
            $0.width.equalTo(self.scrollView.snp.width)
            $0.edges.equalTo(self.scrollView)
        }
        
        dataStackView.addArrangedSubview(bookImageView)
        bookImageView.snp.makeConstraints {
            $0.centerX.equalTo(self.dataStackView)
            $0.height.equalTo(300)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }

        dataStackView.addArrangedSubview(bookTitleLabel)
        bookTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        dataStackView.addArrangedSubview(priceLabel)
        priceLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        dataStackView.addArrangedSubview(authorLabel)
        authorLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        dataStackView.addArrangedSubview(publisherLabel)
        publisherLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        dataStackView.addArrangedSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        dataStackView.addArrangedSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        
    }
    
}

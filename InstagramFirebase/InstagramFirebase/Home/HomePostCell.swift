//
//  HomePostCell.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 4/7/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit

protocol HomePostCellDelegate: class {
  func didTapComment(post: Post)
  func didLike(for cell: HomePostCell)
}

class HomePostCell: UICollectionViewCell {

  weak var delegate: HomePostCellDelegate?

  var post: Post? {
    didSet {
      guard let postImageURL = post?.imageURL else { return }
      photoImageView.loadImage(urlString: postImageURL)

      likeButton.setImage(post?.hasLiked == true ? #imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)

      usernameLabel.text = post?.user.username

      guard let profileImageURL = post?.user.profileImageURL else { return }
      userProfileImageView.loadImage(urlString: profileImageURL)

      setupAttributedCaption()
    }
  }

  // MARK: - Properties

  let userProfileImageView = CustomImageView() <== {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 40 / 2
  }

  let photoImageView = CustomImageView() <== {
    $0.backgroundColor = .white
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }

  let usernameLabel = UILabel() <== {
    $0.text = "Username"
    $0.font = UIFont.boldSystemFont(ofSize: 14)
  }

  lazy var optionsButton = UIButton(type: .system) <== {
    $0.setTitle("•••", for: .normal)
    $0.setTitleColor(.black, for: .normal)
  }

  lazy var commentButton = UIButton(type: .system) <== {
    $0.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
    $0.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
  }

  lazy var likeButton = UIButton(type: .system) <== {
    $0.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
    $0.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
  }

  lazy var sendMessageButton = UIButton(type: .system) <== {
    $0.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
  }

  lazy var bookmarkButton = UIButton(type: .system) <== {
    $0.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
  }

  let captionLabel = UILabel() <== {
    $0.numberOfLines = 0
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  fileprivate func setup() {
    addSubview(userProfileImageView)
    addSubview(usernameLabel)
    addSubview(optionsButton)
    addSubview(photoImageView)
    addSubview(captionLabel)
    setupLayout()
  }

  // MARK: - Handle actions

  func handleComment() {
    guard let post = self.post else { return }
    delegate?.didTapComment(post: post)
  }

  func handleLike() {
    delegate?.didLike(for: self)
  }

}

// MARK: - Layout

extension HomePostCell {

  fileprivate func setupLayout() {
    userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)

    usernameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: photoImageView.topAnchor, right: optionsButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

    optionsButton.anchor(top: topAnchor, left: nil, bottom: photoImageView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 44, height: 0)

    photoImageView.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true

    setupActionButtons()

    captionLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
  }

  fileprivate func setupActionButtons() {
    let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])

    stackView.distribution = .fillEqually
    addSubview(stackView)

    stackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 120, height: 50)

    addSubview(bookmarkButton)
    bookmarkButton.anchor(top: photoImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 50)
  }

  fileprivate func setupAttributedCaption() {
    guard let post = self.post else { return }

    let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
    attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 4)]))

    let timeAgoDisplay = post.creationDate.timeAgoDisplay()
    attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.gray]))

    self.captionLabel.attributedText = attributedText
  }

}

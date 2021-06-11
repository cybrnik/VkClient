//
//  NewsModel.swift
//  Hw1
//
//  Created by Nikita on 05.06.2021.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let groups = try? newJSONDecoder().decode(Groups.self, from: jsonData)

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let news = try? newJSONDecoder().decode(News.self, from: jsonData)

import Foundation

// MARK: - News
struct NewsModel: Codable {
    let response: ResponseNews
}

// MARK: - Response
struct ResponseNews: Codable {
    let items: [ResponseItem]
    let profiles: [Profile]
    let groups: [GroupNews]
    let nextFrom: String

    enum CodingKeys: String, CodingKey {
        case items, profiles, groups
        case nextFrom = "next_from"
    }
}

// MARK: - Group
struct GroupNews: Codable {
    let id: Int
    let name, screenName: String
    let isClosed: Int
    let type: GroupType
    let photo50, photo100, photo200: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
}

enum GroupType: String, Codable {
    case group = "group"
    case page = "page"
}

// MARK: - ResponseItem
struct ResponseItem: Codable {
    let sourceID, date: Int
    let canDoubtCategory, canSetCategory: Bool?
    let postType: PostTypeEnum?
    let text: String?
    let signerID, markedAsAds: Int?
    let attachments: [Attachment]?
    let postSource: PostSource?
    let comments: Comments?
    let likes: PurpleLikes?
    let reposts: Reposts?
    let views: Views?
    let isFavorite: Bool?
    let postID: Int?
    let type: PostTypeEnum
    let photos: Photos?
    let friends: Friends?

    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        case canDoubtCategory = "can_doubt_category"
        case canSetCategory = "can_set_category"
        case postType = "post_type"
        case text
        case signerID = "signer_id"
        case markedAsAds = "marked_as_ads"
        case attachments
        case postSource = "post_source"
        case comments, likes, reposts, views
        case isFavorite = "is_favorite"
        case postID = "post_id"
        case type, photos, friends
    }
}

// MARK: - Attachment
struct Attachment: Codable {
    let type: AttachmentType
    let photo: LinkPhoto?
    let link: Link?
    let doc: Doc?
    let video: AttachmentVideo?
}

// MARK: - Doc
struct Doc: Codable {
    let id, ownerID: Int
    let title: String
    let size: Int
    let ext: String
    let date, type: Int
    let url: String
    let preview: Preview
    let accessKey: String

    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case title, size, ext, date, type, url, preview
        case accessKey = "access_key"
    }
}

// MARK: - Preview
struct Preview: Codable {
    let photo: PreviewPhoto
    let video: VideoElement
}

// MARK: - PreviewPhoto
struct PreviewPhoto: Codable {
    let sizes: [VideoElement]
}

// MARK: - VideoElement
struct VideoElement: Codable {
    let src: String?
    let width, height: Int
    let type: SizeType?
    let fileSize: Int?
    let url: String?
    let withPadding: Int?

    enum CodingKeys: String, CodingKey {
        case src, width, height, type
        case fileSize = "file_size"
        case url
        case withPadding = "with_padding"
    }
}

enum SizeType: String, Codable {
    case d = "d"
    case i = "i"
    case m = "m"
    case o = "o"
    case p = "p"
    case q = "q"
    case r = "r"
    case s = "s"
    case w = "w"
    case x = "x"
    case y = "y"
    case z = "z"
}

// MARK: - Link
struct Link: Codable {
    let url: String
    let title: String
    let caption: String?
    let linkDescription: String
    let photo: LinkPhoto
    let button: Button?

    enum CodingKeys: String, CodingKey {
        case url, title, caption
        case linkDescription = "description"
        case photo, button
    }
}

// MARK: - Button
struct Button: Codable {
    let title: String
    let action: Action
}

// MARK: - Action
struct Action: Codable {
    let type: String
    let url: String
}

// MARK: - LinkPhoto
struct LinkPhoto: Codable {
    let albumID, date, id, ownerID: Int
    let hasTags: Bool
    let sizes: [VideoElement]
    let text: String
    let userID: Int
    let accessKey: String?
    let postID: Int?

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case hasTags = "has_tags"
        case sizes, text
        case userID = "user_id"
        case accessKey = "access_key"
        case postID = "post_id"
    }
}

enum AttachmentType: String, Codable {
    case doc = "doc"
    case link = "link"
    case photo = "photo"
    case video = "video"
}

// MARK: - AttachmentVideo
struct AttachmentVideo: Codable {
    let accessKey: String
    let canComment, canLike, canRepost, canSubscribe: Int
    let canAddToFaves, canAdd, comments, date: Int
    let videoDescription: String
    let duration: Int
    let image, firstFrame: [VideoElement]
    let width, height, id, ownerID: Int
    let title: String
    let isFavorite: Bool
    let trackCode: String
    let type: AttachmentType
    let views: Int

    enum CodingKeys: String, CodingKey {
        case accessKey = "access_key"
        case canComment = "can_comment"
        case canLike = "can_like"
        case canRepost = "can_repost"
        case canSubscribe = "can_subscribe"
        case canAddToFaves = "can_add_to_faves"
        case canAdd = "can_add"
        case comments, date
        case videoDescription = "description"
        case duration, image
        case firstFrame = "first_frame"
        case width, height, id
        case ownerID = "owner_id"
        case title
        case isFavorite = "is_favorite"
        case trackCode = "track_code"
        case type, views
    }
}

// MARK: - Comments
struct Comments: Codable {
    let count, canPost: Int
    let groupsCanPost: Bool?

    enum CodingKeys: String, CodingKey {
        case count
        case canPost = "can_post"
        case groupsCanPost = "groups_can_post"
    }
}

// MARK: - Friends
struct Friends: Codable {
    let count: Int
    let items: [FriendsItem]
}

// MARK: - FriendsItem
struct FriendsItem: Codable {
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
    }
}

// MARK: - PurpleLikes
struct PurpleLikes: Codable {
    let count, userLikes, canLike, canPublish: Int

    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
        case canLike = "can_like"
        case canPublish = "can_publish"
    }
}

// MARK: - Photos
struct Photos: Codable {
    let count: Int
    let items: [PhotosItem]
}

// MARK: - PhotosItem
struct PhotosItem: Codable {
    let albumID, date, id, ownerID: Int
    let hasTags: Bool
    let accessKey: String
    let postID: Int?
    let sizes: [VideoElement]
    let text: String
    let userID: Int
    let likes: FluffyLikes
    let reposts: Reposts
    let comments: Views
    let canComment, canRepost: Int

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case hasTags = "has_tags"
        case accessKey = "access_key"
        case postID = "post_id"
        case sizes, text
        case userID = "user_id"
        case likes, reposts, comments
        case canComment = "can_comment"
        case canRepost = "can_repost"
    }
}

// MARK: - Views
struct Views: Codable {
    let count: Int
}

// MARK: - FluffyLikes
struct FluffyLikes: Codable {
    let userLikes, count: Int

    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}

// MARK: - Reposts
struct Reposts: Codable {
    let count, userReposted: Int

    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
}

// MARK: - PostSource
struct PostSource: Codable {
    let type: PostSourceType
}

enum PostSourceType: String, Codable {
    case api = "api"
    case vk = "vk"
}

enum PostTypeEnum: String, Codable {
    case friend = "friend"
    case post = "post"
    case wallPhoto = "wall_photo"
}

// MARK: - Profile
struct Profile: Codable {
    let firstName: String
    let id: Int
    let lastName: String
    let canAccessClosed, isClosed: Bool
    let sex: Int
    let screenName: String
    let photo50, photo100: String
    let onlineInfo: OnlineInfo
    let online: Int
    let onlineMobile, onlineApp: Int?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case canAccessClosed = "can_access_closed"
        case isClosed = "is_closed"
        case sex
        case screenName = "screen_name"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case onlineInfo = "online_info"
        case online
        case onlineMobile = "online_mobile"
        case onlineApp = "online_app"
    }
}

// MARK: - OnlineInfo
struct OnlineInfo: Codable {
    let visible: Bool
    let isOnline, isMobile: Bool?
    let lastSeen, appID: Int?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case visible
        case isOnline = "is_online"
        case isMobile = "is_mobile"
        case lastSeen = "last_seen"
        case appID = "app_id"
        case status
    }
}

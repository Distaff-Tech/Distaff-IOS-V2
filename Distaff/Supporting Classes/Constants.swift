
import Foundation
import UIKit


let appDelegateRef = UIApplication.shared.delegate as! AppDelegate
let userdefaultsRef = UserDefaults.standard
let appCurrentVersion = Int(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
let homeStoryBoard = UIStoryboard(name: StoryBoardName.homeStoryboard, bundle: nil)
let loginStoryBoard = UIStoryboard(name: StoryBoardName.loginStoryboard, bundle: nil)


private enum BaseUrl : String {
    case local = "http://157.245.218.104:8000/"
//    case live = "http://3.21.18.92:8001/"
//    case live = "http://127.0.0.1:8000/"
    case live = "http://3.21.18.92/"
    case development = "http://3.21.18.92:7000/"
}
struct WebServicesApi {
    static let baseUrl = BaseUrl.live.rawValue
    static let developmentUrl = BaseUrl.development.rawValue

//    static let imageBaseUrl = "http://3.21.18.92:8001"  // live
//    static let imageBaseUrl = "http://127.0.0.1:8000"  // live
    static let imageBaseUrl = "http://3.21.18.92"  // live
    //static let imageBaseUrl = "http://157.245.218.104:8000"  // local
    
    static let signUp = WebServicesApi.developmentUrl +  "signup"
    static let signIn = WebServicesApi.developmentUrl +  "login"
    static let createProfile = WebServicesApi.developmentUrl +  "create_profile"
    static let addCard = WebServicesApi.baseUrl +  "add_card"
    
    static let forgotPassword = WebServicesApi.baseUrl +  "sendverifylink"
    static let socialLogin = WebServicesApi.baseUrl +  "social_login"
    static let get_colour_size = WebServicesApi.developmentUrl +  "get_fabric_size"
    static let addpost = WebServicesApi.developmentUrl +  "addpost"
    
    static let get_homePage = WebServicesApi.developmentUrl +  "get_homePage?"
    static let like_dislike_post = WebServicesApi.developmentUrl +  "like_dislike_post"
    static let set_favourite = WebServicesApi.baseUrl +  "set_favourite"
    static let report_user = WebServicesApi.baseUrl +  "report_user"
    static let getcomment = WebServicesApi.baseUrl +  "getcomment/"
    static let deleteComment = WebServicesApi.baseUrl +  "deletecomment"
    static let postcomment = WebServicesApi.baseUrl +  "postcomment"
    static let get_post = WebServicesApi.developmentUrl +  "get_post/"
    static let addToCart = WebServicesApi.developmentUrl +  "addtocart"
    static let delete_card = WebServicesApi.baseUrl +  "delete_card"
    
    static let contactUs = WebServicesApi.baseUrl +  "contactus"
    static let changePassword = WebServicesApi.baseUrl +  "changePassword"
    static let logout = WebServicesApi.developmentUrl +  "logout"
    static let get_list_cards = WebServicesApi.baseUrl +  "get_list_cards"
    static let set_onOffNotification = WebServicesApi.baseUrl +  "set_onOffNotification"
    static let get_favourite = WebServicesApi.baseUrl +  "get_favourite?"
    
    static let get_message = WebServicesApi.baseUrl +  "get_message"
    static let send_message = WebServicesApi.baseUrl +  "send_message"
    static let chat_history = WebServicesApi.baseUrl +  "chat_history?"
    static let delete_message = WebServicesApi.baseUrl +  "delete_message"
    
    static let get_cart_posts = WebServicesApi.baseUrl +  "get_cart_posts"
    static let delete_cart_post = WebServicesApi.baseUrl +  "delete_cart_post"
    static let get_address = WebServicesApi.baseUrl +  "get_address"
    static let add_address = WebServicesApi.baseUrl +  "add_address"
    static let delete_address = WebServicesApi.baseUrl +  "delete_address"
    static let order_create = WebServicesApi.baseUrl +  "order_create"
    static let search_user = WebServicesApi.baseUrl +  "search_user?"
    static let userprofile = WebServicesApi.developmentUrl +  "userprofile/"
    static let set_follow = WebServicesApi.baseUrl +  "set_follow"
    static let get_followers = WebServicesApi.baseUrl +  "get_followers"
    static let get_following = WebServicesApi.baseUrl +  "get_following"
    
    static let my_request = WebServicesApi.baseUrl +  "my_request?"
    static let past_orders = WebServicesApi.baseUrl +  "past_orders?"
    static let accept_DeclineOrder = WebServicesApi.baseUrl +  "accept_order"
    static let order_delete = WebServicesApi.baseUrl +  "order_delete"
    static let orderDetail = WebServicesApi.baseUrl +  "order_detail"
    static let cancelOrder = WebServicesApi.baseUrl +  "cancel_order"
    static let updateToken = WebServicesApi.baseUrl +  "update_token"
    static let notificationList = WebServicesApi.baseUrl +  "notification_list"
    static let deleteNotification = WebServicesApi.baseUrl +  "delete_notification"
    static let getCustomList = WebServicesApi.baseUrl +  "getCustomList"
    
    // Add bank
    static let addBank = WebServicesApi.baseUrl +  "add_bank"
    
}



//MARK:- CELLS IDENTIFERS
struct CellIdentifers {
    static let settingsTableNotificationCell = "SettingsTableNoticationCell"
    static let settingsTableOtherCell = "SettingsTableOtherCell"
    static let myCardsTableViewCell = "MyCardsTableViewCell"
    static let commentsTableViewCell = "CommentsTableViewCell"
    static let homeTableCell = "HomeTableCell"
    static let selectAddressTableViewCell = "SelectAddressTableViewCell"
    static let messageTableViewCell = "MessageTableViewCell"
    static let myProfileGridCell = "MyProfileGridCell"
    static let myprofileListCell = "MyprofileListCell"
    
    //Chat
    static let chatRightTableViewCell = "ChatRightTableViewCell"
    static let chatLeftTableViewCell = "ChatLeftTableViewCell"
    
    
    static let notificationTableFollowCell = "NotificationTableFollowCell"
    static let notificationTableOtherCell = "NotificationTableOtherCell"
    static let clothSizeCollectionCell = "ClothSizeCollectionCell"
    
    static let clothColorCollectionCell = "ClothColorCollectionCell"
    static let shoppingBagTableViewCell = "ShoppingBagTableViewCell"
    static let shoppingFooterTableViewCell = "ShoppingFooterTableViewCell"
    static let selectPaymentTableCell = "SelectPaymentTableCell"
    static let searchTableViewCell = "SearchTableViewCell"
    static let clothMaterialTableViewCell = "ClothMaterialTableViewCell"
    static let chooseColorCollectionViewCell = "ChooseColorCollectionViewCell"
    static let postImagesCollectionCell = "PostImagesCollectionCell"
    
    // my order
    static let myRequestTableViewCell = "MyRequestTableViewCell"
    static let pastOrdersTableViewCell = "PastOrdersTableViewCell"
    
    // custom Design
    static let customDesignListCollectionCell = "CustomDesignListCollectionCell"
    static let patternCollectionViewCell = "PatternCollectionViewCell"
    static let customDesignChooseColorCollectionCell = "CustomDesignChooseColorCollectionCell"
    static let customDesignShapeCell = "CustomDesignShapeCell"
    static let customDesignSewCell = "CustomDesignSewCell"
    
}


struct AppColors {
    static let appColorBlue = #colorLiteral(red: 0.06666666667, green: 0.5019607843, blue: 0.5058823529, alpha: 1)
}


//MARK:- CONSTAINTS IDENTIFERS
struct ConstarinstIdentifers {
    static let toolBarBottomAnchor = "toolbarBottomAnchor"
}

//MARK:- RESTORE IDENTIFERS
struct RestorationIdentifer {
    static let stickerView = "StickerView"
    static let shapeView = "Shape View"
    static let noDataLabel = "No Data label"
    static let fabricImage = "Fabric Image"
    static let frontView = "FrontView"
    static let backView = "BackView"
    static let Endview = "EndView"
    static let outerArea = "OuterArea"
    static let leftArm = "LeftArm"
    static let rightArm = "RightArm"
    static let availableView = "available View"
    static let protectiveView = "ProtectiveView"
    static let blurView = "BlurView"
    static let CutArea = "CutArea"
    
}
//MARK:- ACCESSIBILITY IDENTIFERS
struct AccesibilityIdentifer {
    static let extraPriceShape = "extraPriceShape"
    
}


enum CustomDesignsShapeTypes {
    case reactange
    case circle
}

//MARK:- STORY BOARD IDENTIFERS
struct ViewControllersIdentifers {
    static let loginVC = "LoginVC"
    static let forgotPassword = "ForgotPasswordVC"
    static let forgotPasswordPopup = "ForgorPasswordPopup"
    static let signUpVC = "SignUpVC"
    static let termsConditionVC = "TermsConditionVC"
    static let createProfileVC = "CreateProfileVC"
    static let completeProfileVC = "CompleteProfileVC"
    static let paymentVC = "SetPaymentVC"
    static let tabbarVC = "TabbarVC"
    static let myProfileVC = "MyProfileVC"
    
    static let helpAndSupportVC = "HelpAndSupportVC"
    static let changePasswordVC = "ChangePasswordVC"
    static let webVC = "WebVC"
    static let myCardsVC = "MYCardsVC"
    static let commentsVC = "CommentsVC"
    static let addNewAddressVC = "AddNewAddressVC"
    static let enterCVVPopupVC = "EnterCVVPopupVC"
    static let orderSuccessPopupVC = "OrderSuccessPopupVC"
    static let selectAddressVC = "SelectAddressVC"
    
    static let createPostPopup = "CreatePostPopupVC"
    
    static let chatVC = "ChatVC"
    static let notificationVC = "NotificationVC"
    static let settingsVC = "SettingsVC"
    
    static let myFavouriteVC = "MyFavouritesVC"
    
    static let createPostNavigation = "CreatePostNavigation"
    static let orderHistoryVC = "OrderHistoryVC"
    static let orderDetailVC = "OrderDetailVC"
    
    static let postDetailVC = "PostDetailVC"
    
    static let shoppingBagVC = "ShoppingBagVC"
    static let selectPaymentVC = "SelectPaymentVC"
    static let initialNavigation = "InitialNavigation"
    
    static let addPostVC = "AddPostVC"
    static let clothMaterialPoupVC = "ClothMaterialPoupVC"
    static let chooseColorVC = "ChooseColorVC"
    static let orderSummaryVC = "OrderSummaryVC"
    static let customDesignVC = "CustomDesignVC"
    static let promotionalPostDetailVC = "PromotionalPostDetailVC"
    static let chooseShapePoupVC = "ChooseShapeAreaPopupVC"
    
    static let addBankVC = "AddBankVC"
    
}

//MARK:- STORYBOARD NAME
struct StoryBoardName {
    static let loginStoryboard = "Login"
    static let homeStoryboard = "Home"
}

struct TextFieldsTag {
    static let email = 5
    static let password = 6
    static let confirmPassword = 6
    static let firstname = 7
    static let lastName = 8
    static let fullName = 9
    static let other = 10
}


struct ValidationMessages {
    static let enterStoryName  = "Story name field can't be empty"
    static let selectImage  = "Please select image first"
    static let choosePlan  = "Please choose plan first"
}

struct OtherMessages {
    static let tutorialMessage  = "This is the printing area of T Shirt. You can add your custom designs in this area.You can also change printing area from top size dropdown"
    static let savePhotoMessage  = "Photo Saved Successfully"
    static let noDataLabelMessage  = "Story list found empty"
    static let cameraNotFound  = "Something went wrong while opening camera."
    static let appUpdateAvailable  = "An updated version of Insta Story is available.Please update your application"
    static let deleteStoryAlertMessage  = "are your sure want to delete selected item(S)?"
    static let planPurchasedAlertMessage  = "Subscription added successfully"
    static let planPurchasedFailierAlertMessage  = "Can't make purchases"
}


//MARK:- FONTS USED IN APP:--
struct AppFont {
    static let fontRegular = "ProximaNova-Regular"
    static let fontSemiBold = "ProximaNova-Semibold"
    static let fontDancingScript = "DancingScript-Regular"
}

struct UserDefaultsKeys {
    static let  deviceId = "DeviceId"
    static let  hasAcceptedTermsCondition = "HasAcceptedTermsCondition"
    static let  isUserLogedIn = "IsUserLogedIn"
    static let  userInfo = "UserInfo"
    static let  cartCount = "cartCount"
    static let  bankInfo = "bankInfo"
    static let isTutorialDisplayed = "isTutorialDisplayed"
}

struct NotificationObservers {
    static let refreshChatList = "refreshChatList"
    static let refreshProfile = "refreshProfile"
    static let refreshOrderDetail = "refreshOrderDetail"
    static let refreshNotificationList = "refreshNotificationList"
}

struct PushNotificationsType {
    static let like = "like"
    static let follow = "follow"
    static let OrderPlace = "Order place"
    static let message = "message"
    static let orderAccept = "Order Accept"
    static let postDisabled = "post disabled"
}


struct WebUrlLinks {
    static let followUs = "https://instagram.com/instastoryapp1?igshid=8lergm9cv6tf"
    static let privacyPolicy = "http://3.21.18.92:8000/privacy"
    static let termsOfUse = "http://3.21.18.92:8000/terms_conditions"
    static let cancellationPolicy = "http://3.21.18.92:8000/cancel"
}

struct DeviceType {
    static let deviceType = "I"
}

struct AppInfo {
    static let appName = "Distaff"
    static let appCurrentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    static let appStoreId = "1526038082"
    static let appStoreUrl = "https://apps.apple.com/us/app/insta-story/id1475461543?ls=1"
    static let appStoreSharedSecret = "36a98ef5b0924cdca1ed4685a3740a39"
    static let splashScreenSleepTime = 2
    static let navigationBarTitleSize = 17
    static let toastDisplayTime = 1.7
    static let deveiceType = "I"
    static let clientId = "365079917521-v3tp5dn741hli6nhc2cuf8q8kehpcgqf.apps.googleusercontent.com"
    static let facebookUrlScheme = "fb295457538226320"
}

struct InstagramInfo {
    
    //    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    //    static let INSTAGRAM_USER_INFO = "https://api.instagram.com/v1/users/self/?access_token="
    //    static let INSTAGRAM_CLIENT_ID = "05de7aff1b784bda8b45a8ebec0dc930"
    //    static let INSTAGRAM_CLIENTSERCRET = "44cd8acf721541dfa87a18179255fa9d"
    //    static let INSTAGRAM_REDIRECT_URI = "http://www.theappguruz.com/blog/instagram-integration-android-application-tutorial"
    //    static var INSTAGRAM_ACCESS_TOKEN = ""
    //    static let INSTAGRAM_SCOPE = "follower_list+public_content" /* add whatever scope you need https://www.instagram.com/developer/authorization/ */
    
    
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    static let INSTAGRAM_USER_INFO = "https://api.instagram.com/v1/users/self/?access_token="
    static let INSTAGRAM_CLIENT_ID = "2571951856355497"
    static let INSTAGRAM_CLIENTSERCRET = "d6f34ae287955e44a8f1bfaf915033ea"
    static let INSTAGRAM_REDIRECT_URI = "https://www.netsetsoftware.com/"
    static var INSTAGRAM_ACCESS_TOKEN = ""
    static let INSTAGRAM_SCOPE = "follower_list+public_content" /* add whatever scope you need https://www.instagram.com/developer/authorization/ */
    
}




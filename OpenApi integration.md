# OpenAPI integration  [![version](https://img.shields.io/badge/iOS_CocoaPods_version-1.0.1-green)](https://github.com/CocoaPods/Specs/blob/master/Specs/3/4/b/OpenAPI/1.0.1/OpenAPI.podspec.json)

**Table of Contents**

- [What is OpenAPI](#what-is-openapi)
>- [Bypass Silence](#bypass-silence)
>- [Auto Subscribe to nearest communities](#auto-subscribe-to-nearest-communities)
>- [Notification translation to user choice language](#notification-translation-to-user-choice-language)
- [Requirements](#requirements)
- [Getting Started](#getting-started)
>- [Configuration](#configuration)
>>- [Install framework With Pods](#setup-ios-withpods)
>>- [Install framework Manually](#setup-ios-manually)
>>- [Authentication](#authentication)
>>- [RegisterPushToken](#registerpushtoken)
>>- [Configure Push Notifications](#configure-push-notifications)
>>- [Project PreRequisites](#override-dnd-ios)
- [Integration](#integration)
>- [Bypass Silence Method](#setup-ios-bypass-silence)
>- [Notification actions handling](#notification-actions-handling)
- [How to test](#how-to-test)
- [Language translation](#language-translation)
- [References](#references)


## What is OpenAPI
This library is built by In-telligent with proprietary code to use below features in your iOS application:

### Bypass Silence:
Override feature will Bypass the Silence on the IOS device and raises the alarms / alerts for the following scenarios:
1. When the Device is in Silence Mode
2. When Device is in  Silence Mode and the App is in idle state
3. When Device is in  Silence Mode and the App is in BackGround state
4. When Device is in  Silence Mode and the App is in Terminated state
5. When Device is in  Silence Mode and the Device is locked State.
6. When Device is in  Silence Mode and the Device is In-Active State.
7. When Device is in  Silence Mode and the Fight Mode enables with wifi active state.


### Auto Subscribe to nearest communities:
In-telligent system comes with geofence based communities to group audience. This feature allows the device to automatically subscribe to all the nearest In-telligent communities. The application will run in the background and listen for the device location change events and auto-subscribe or un-subscribe to respective communities. The Auto-subscribe functionality triggers in two scenarios:

+ **When user moves away from Geo-fence range:**
    +  OpenAPI will un-subscribe the user from community.

+  **When user enter a Geo-fence range:**
    +  OpenAPI will subscribe the user to the community.


### Notification translation to user choice language
+ The OpenAPI can translate the notifications (delivered from in-telligent system) into any language of user choice from over 120+ languages.


## Requirements

- Xcode 13 above
- iOS Mobile Version 14.0 and above
- Open API library file or with Pod
- Partner Token (Partner token is to authenticate your app as client. If you don’t have the partner token, email us at support@in-telligent.com)
- Apple developer account
  + Server-side implementation -
    + Ensure the App Owner’s server API implementation is ready to send notification payload.

## Getting Started
### Configuration

#### Install framework With Pods <a id='setup-ios-withpods'></a>
1. Open the XCode project in which you would like to integrate this framework.
2. Add pod 'OpenAPI' into the pod file.

   ```swift
   pod 'OpenAPI'
   ```
   
#### Install framework Manually <a id='setup-ios-manually'></a>
1. Open the XCode project in which you would like to integrate this framework.
2. Drag and drop “OpenAPI.framework” into the bundle folder.
3. Make sure this framework is added in both “Embedded Binaries” and “Linked Framework and libraries”
4. Add the following third-party dependency libraries along with the OpenAPI with the versions:
   ```swift
   pod 'Alamofire', '~> 4.9.1’
   pod "RealmSwift", "3.17.3"
   pod "SwiftyJSON"
   , "~> 5.0.0"
   ```
5. Install the above dependency frameworks by using cocoa pods.
   Ref: https://guides.cocoapods.org/using/getting-started.html
6. Add .mp3 files into your project bundle which are available in the framework zip folder.
7. Add OpenAPI Framework in Link Binary with Libraries at Build Phases and make optional (Other wise it leads to crash after build generation)
8. To generate the build please follow below steps
+ Select Project Target > Edit Scheme > Archive > Pre-Actions
+ Add Script
+ Provide build settings from – Select the App Target
+ Add the below Script
   ```swift
   FRAMEWORK="OpenAPI"
   FRAMEWORK_EXECUTABLE_PATH="${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/$FRAMEWORK.framework/$FRAMEWORK"
   EXTRACTED_ARCHS=()
   for ARCH in $ARCHS
   do
   lipo -extract "$ARCH" "$FRAMEWORK_EXECUTABLE_PATH" -o "$FRAMEWORK_EXECUTABLE_PATH-$ARCH"
   EXTRACTED_ARCHS+=("$FRAMEWORK_EXECUTABLE_PATH-$ARCH")
   done
   lipo -o "$FRAMEWORK_EXECUTABLE_PATH-merged" -create "${EXTRACTED_ARCHS[@]}"
   rm "${EXTRACTED_ARCHS[@]}"
   rm "$FRAMEWORK_EXECUTABLE_PATH"
   mv "$FRAMEWORK_EXECUTABLE_PATH-merged" "$FRAMEWORK_EXECUTABLE_PATH"
   ```
### Dependencies

3. Import the following third-party dependencies along with the OpenAPI:
   ```swift
   pod 'Alamofire', '~> 4.9.1’
   pod "RealmSwift", "3.17.3"
   pod "SwiftyJSON", "~> 5.0.0"
   ```

Permissions:
   Add following permissions to. plist.
```
<dict>
<key>CFBundleDevelopmentRegion</key>
<string>$(DEVELOPMENT_LANGUAGE)</string>
<key>CFBundleDisplayName</key>
<string>NotificationServiceExtension</string>
<key>CFBundleExecutable</key>
<string>$(EXECUTABLE_NAME)</string>
<key>CFBundleIdentifier</key>
<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
<key>CFBundleInfoDictionaryVersion</key>
<string>6.0</string>
<key>CFBundleName</key>
<string>$(PRODUCT_NAME)</string>
<key>CFBundlePackageType</key>
<string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
<key>CFBundleShortVersionString</key>
<string>$(MARKETING_VERSION)</string>
<key>CFBundleVersion</key>
<string>$(CURRENT_PROJECT_VERSION)</string>
<key>NSExtension</key>
<dict>
<key>NSExtensionPointIdentifier</key>
<string>com.apple.usernotifications.service</string>
<key>NSExtensionPrincipalClass</key>
<string>$(PRODUCT_MODULE_NAME).NotificationService</string>
</dict>
</dict>
```
## Authentication
Authentication is mandatory to use any service from OpenAPI.
   There are 2 methods for the authentication process:
   + ***CheckToken***: – Check if the app is already authenticated.
   + ***Authorization***: - If the authentication token is not available, checkToken method returns false. Then a call to “authorization” method is required to get the authentication token and store it in cache.
```swift
        OpenAPI.authorization() {error, isTokenUpdated  in
            if isTokenUpdated {
                KeyChainStorage.shared.token = OpenAPI.token
                OpenAPI.start(self)
                completion?(OpenAPI.token, nil)
                //still not required to pass token through completion handler , but just in case passing
            } else {
                completion?(nil ,INError(message: error))
            }
        }
```
### RegisterPushToken
In Order to receive PushKit notification / Regular notification from In-Telligent server, need to register captured device tokens (Regular Push token and VoIP Push token) with In-Telligent using OpenAPI method “registerPushKitToken” as bellow,
   ```swift
        OpenAPI.registerPushKitToken(voipPushToken: voipPushToken, regularPushToken: regularPushToken){
            (status) in 
            completion(status)
        }
   ```
### Configure Push Notifications
#### Project PreRequisites <a id='override-dnd-ios'></a>
1. In the project target folder -> Capabilities -> background modes enable the following:
    + Audio, Airplay, and Picture in Picture
    + Location updates
    + Voice over IP
    + Background fetch
    + Remote notifications
2. In Capabilities, enable Push notifications.
3. Register the application with the bundle identifier in apple developer website (https://developer.apple.com/) and enable VOIP services on the apple developer portal with the app ID and then create:
    1. Certificates: (Refer to the attached document - iOS Certificates creation process)
    2. Profiles: (Refer to the attached document - iOS Certificates creation process)
    3. Integrate: Install certificates by double clicking on the certificates. This is to run the development application in iPhone physical device and to send push notification using Pusher client.
       Ref: (attached document – iOS Certificates creation process)
4. For VOIP services,
   + Generate a P8 file in KEYS section in developer portal (Ref: attached document – iOS Certificates creation process)
   + Download the generated file
   + Integrate the above certificates with backend web services, which will initiate the notification (app owner’s server)
5. For further use, need to capture device tokens from the following delegates methods
   ```swift
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken
            deviceToken: Data){
            let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
            print("Pushtoken regular: \(deviceTokenString)")
            }

        func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType){
            var pToken: String = ""
                for i in 0 ..< credentials.token.count {
            pToken += String(format: "%02.2hhx", credentials.token[i] as CVarArg)
        }
                print("Pushtoken voip: \(pToken)")
    }
   ```

## Integration
### Bypass Silence Method <a id='setup-ios-bypass-silence'></a>
On AppDelegate class, In “didReceiveRemoteNotification” delegate method, Call OpenAPI.relayPushNotification method with the received payload. The OpenAPI will take care of bypassing the Silent settings and alert the user with loudest possible sound from the device.
```swift
 func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
     OpenAPI.relayPushKitNotification(dictionaryPayload: userInfo)
     completionHandler(.newData)
 }
```

### Entitlements communitcation from Client App
```
1. In the project target -> Signin & Capabilities -> Select '+' Buttion -> Select APP GROUPS
        -> Select '+' inside the App Group section
        -> You will get the dialog box with (group.)
        -> Add the group package as group.(Your app Bundle Identifier)
2. InsessionManager can able to access the group entitilements id from both App and notification extension. 
```

### Notification actions handling
Notification will have 1 options i.e., Open. This call actions are to be handled in the application receiver class.
example: Alert Details information class (From recievers application)
```swift
  if let notification = notification {
         API.markOpened(notification, success: nil, failure: nil)
         self.getNotificationInfoCall(innotifcation: notification)
     }
```
To implement delete functionality, the following steps must be taken:
Deleting the alert locally which is stored by the Realm.
```swift
        Realm.write { (blockRealm) in
         blockRealm.delete(self)
     }
```
## How to test
Using In-Telligent Portal. If you are using In-telligent system to send alerts, proceed with this approach. Else use your own notification system to send alert and test on mobile application.
+ Launch In-telligent web portal.
+ Prod: https://app.in-telligent.com/
+ Dev: https://app.uat.in-telligent.com/
+ Login using valid credentials (Admin / Community Manager).
+ Select a community from list under Communities tab to send an alert.
+ Once community page is opened, click on “send a community alert” from left sidebar navigation.
+ Enter required fields, select type of alert and click on send button.
+ If everything went well, device should receive the alert and the respective sound. Below is the sample notification payload:
```swift
{
 "data": {
  "payload_version":"2",
  "building": {
   “name":  "Test Community",
   "id":"12345"
  },
 "data": {
  "title": "test alert please ignore",
  "body": "test alert please ignore"
 },
 "notification"{
  "action": "pushNotification",
  "language": "en",
  "id": "12345",
  "type": "normal",
  "suffix": "to refer back to this alert or to see more information, please open the App"
 }
},
"to": "fW40hcEO9PA:APA91bFJr2-nwkSuBfhL3_g2Q3iPZOZGcx-P6B_zVVR_7k1zMDC-qFIYcdzdNE_h2ecRO17Sw2tvcHp7xLkAArajyILRAgYolHJt8CuXo7t66TB48VoOeTdQPI-Mtq0HKjxKPXF4S_BM"
}
```
#### Description of the above payload parameters

+ building: Contains building details like name (building name) and id (building id)
+ data: Contains notification data like title (notification title) and body (notification description)
+ notification: Contains notification parameters like action (notification type), language (notification language), id (notification id), type (alert type) and suffix.
+ Type can be one of -
+ life-safety
+ personal-safety
+ critical
+ ping
+ weather-alert
+ lightning-alert
+ pc-urgent
+ pc-emergency
+ Normal
+ suggested

#### Auto-subscribe (Auto grouping) to nearest communities

Upon authentication, the following method is used to initiate the auto subscription process. This method internally will auto-subscribe the device to the nearest communities (Geofences) and returns the list of subscribed communities to the client application.
```swift
    public static func getSubscribedCommunities() -> [INCommunity] {
     INCommunityManager.shared.getSubscribedCommunities()
 }
 
 OpenAPI.getSubscribedCommunities()
```

The above method will handle the following functionality:
+ Listen and handle location change Events.
+ Perform communities’ subscription and un-subscription, which includes updating Geofences on the device.

## How to test
+ Create new communities from the web portal
+ Launch In-Telligent web portal
+ Prod: https://app.in-telligent.com/
+ Dev: https://app.uat.in-telligent.com/
+ Login using valid credentials (Community Manager / Admin).
+ Create new community from communities tab.
+ Newly created community should be auto-subscribed and listed in device on location changed / on app launch / after a specific time period (Syncing the latest changes is expected to happen in max of 12 hours in the client application). 
+ Note: Sync frequency in production environment is set to 12 hours and in Dev it is set to 15 mins.

## Language translation
Upon authentication, you can translate in-telligent delivered notifications to any other supported language.
To get supported languages
```swift
INLanguageManager.getLanguages({ [weak self] (languages) in
             DispatchQueue.main.async {
                 self?.hideLoader()
                 ///
             }
         }, failure: { [weak self] (error,errorCode) in
             DispatchQueue.main.async {
                 self?.hideLoader()
                 ///
             }
         })

```
To translate the alert into supported languages
```swift
INLanguageManager.getTranslation(for: notification, to: language) { (translation) in
             
             DispatchQueue.main.async {
                 self.hideLoader()
                 ///
             }
         } failure: { (error,errorCode) in
             DispatchQueue.main.async {
                 self.hideLoader()
                 if errorCode == 404 || errorCode == 403 {
                     self.showErrorMessage("There was an error connecting to the server".localized())
                 } else { self.showError(error) }
             }
         }
```

## References
   1. https://chrome.google.com/webstore/detail/restlet-client-rest-api-t/aejoelaoggembcahagimdiliamlcdmfm?hl=en

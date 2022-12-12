# OpenAPI integration ![Supported android api versions](https://img.shields.io/badge/android%20api%20version-from%2026%20to%2033-brightgreen) [![version](https://img.shields.io/badge/version-5.2-green)](https://mvnrepository.com/artifact/com.in-telligent.openapi/openapi)

**Table of Contents**

- [Purpose](#purpose)
>- [Bypass Silence](#bypass-silence)
>- [Auto Subscribe](#auto-subscribe)
>- [Language Translation](#purpose-language-translation)
- [Requirements (Development Environment)](#requirements-development-environment)
>- [iOS](#requirements-ios)
- [Setup Environment](#setup-environment)
>- [iOS - Manually](#setup-ios-Manually)
>- [iOS - With Pods](#setup-ios-withpods)
- [Getting Started](#getting-started)
>- [iOS](#start-ios)
- [About The Framework](#about-the-framework)
- [Entitlements communitcation from Client App](#entitlements-communitcation-from-client-app)
> >- [Project PreRequisites](#override-dnd-ios)
> >- [How to test](#test-override-dnd-ios)
>- [Auto-subscribe (Auto grouping) to nearest communities](#auto-subscribe-auto-grouping-to-nearest-communities)
> >- [iOS](#auto-subscribe-ios)
> >- [How to test](#test-auto-subscribe-ios)
>- [Language translation](#language-translation)
> >- [iOS](#language-translation-ios)
> >- [How to test](#test-language-translation-ios)
>- [Send alerts to all subscribers](#send-alerts-to-all-subscribers)
> >- [iOS](#send-alerts-ios)
> >- [How to test](#test-send-alerts-ios)
>- [Delivered alert status of an alert](#delivered-alert-status-of-an-alert)
>- [Opened alert status](#opened-alert-status)
> >- [iOS](#alert-opened-ios)
>- [Delete an alert](#delete-an-alert)
> >- [iOS](#delete-alert-ios)
- [Integration with In-Telligent](#integration-with-in-telligent)
- [References](#references)


## Purpose
This document is to provide guidance on how to integrate In-Telligent’s Open API Library (Framework) with your Android and iOS mobile applications.
The Open API library has 3 features:

### Bypass Silence:
Override feature will Bypass the Silence on the IOS device and raises the alarms / alerts for the following scenarios:
1. When the Device is in Silence Mode
2. When Device is in  Silence Mode and the App is in idle state
3. When Device is in  Silence Mode and the App is in BackGround state
4. When Device is in  Silence Mode and the App is in Terminated state
5. When Device is in  Silence Mode and the Device is locked State.
6. When Device is in  Silence Mode and the Device is In-Active State.
7. When Device is in  Silence Mode and the Fight Mode enables with wifi active state.


### Auto Subscribe:
Also known as Auto Grouping. This feature allows the device to automatically subscribe to all the nearest In-Telligent communities. This service will run in the background and automatically subscribes to nearest communities in following scenarios:
1. When the app is in background state
2. When the app is in foreground state

### Language Translation: <a id='purpose-language-translation'></a>
The alert notification can be translated into a different language for better reading in a comfortable language.

## Requirements (Development Environment)

### iOS: <a id='requirements-ios'></a>
- Xcode 12 above
- iOS Mobile Version 13.0 and above
- Open API library file / with Pod
- Partner Token
- Apple developer account
  + Server-side implementation -
    + Ensure the App Owner’s server API implementation is ready to send notification payload as per the sample listed in section 6
* Supplied by In-Telligent

## Setup Environment
The following describes the iOS integration dependencies for the OpenAPI library.

### iOS - Manually <a id='setup-ios-Manually'></a>
1. Open the XCode project in which you would like to integrate this framework.
2. Drag and drop “OpenAPI.framework” into the bundle folder.
3. Make sure this framework is added in both “Embedded Binaries” and “Linked Framework and libraries”
4. Add the following third-party dependency libraries along with the OpenAPI with the versions:
   ```swift
   pod 'Alamofire', '~> 4.9.1’
   pod "RealmSwift", "3.17.3"
   pod "SwiftyJSON", "~> 5.0.0"
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
   
### iOS - With Pods <a id='setup-ios-withpods'></a>
1. Open the XCode project in which you would like to integrate this framework.
2. Add pod 'OpenAPI' into the pod file.

   ```swift
   pod 'OpenAPI'
   ```
### Dependencies

3. Import the following third-party dependencies along with the OpenAPI:
   ```swift
   pod 'Alamofire', '~> 4.9.1’
   pod "RealmSwift", "3.17.3"
   pod "SwiftyJSON", "~> 5.0.0"
   ```
   
## Getting Started
### iOS <a id='start-ios'></a>
1. Authentication: Before we call any service from OpenAPI, we need to authenticate the Partner token which was received from In-Telligent.
   There are 2 methods for the authentication process:
   1. CheckToken: – This is a method which looks for the authentication token in the application cache. (This will be by default false in the first run).
   2. authorization: - If the authentication token is not available, checkToken method returns false. Then a call to “authorization” method is required to get the authentication token and store it in cache.
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

## About The Framework
The In-Telligent Open API framework supports the integration of In-Telligent proprietary code into any mobile application. Features include customer authentication, sending push notifications to subscribed users, automatically grouping users into “communities” based on real-time location and translation of text into any supported language.

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
6. In Order to receive PushKit notification / Regular notification from In-Telligent server, need to register captured device tokens (Regular Push token and VoIP Push token) with In-Telligent using OpenAPI method “registerPushKitToken” as bellow,
   ```swift
        OpenAPI.registerPushKitToken(voipPushToken: voipPushToken, regularPushToken: regularPushToken){
            (status) in 
            completion(status)
        }
   ```
7. When the Regular push notification payload is received on the delegate method, call the Open API method relayPushKitNotification and pass the received payload. The Open API library will handle the notification with the appropriate sound.
   ```swift
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        OpenAPI.relayPushKitNotification(dictionaryPayload: userInfo)
        completionHandler(.newData)
    }
   ```
8. When the PushKit payload is received on the delegate method, call the Open API method relayPushKitNotification and pass the received payload.   The Open API library will handle the notification with the appropriate sound.
   ```swift
    func pushRegistry(_ registry: PKPushRegistry, deidReceiveIncomingPushWith rawPayload: PKPushPayload, for type: PKPushType){
        debugPrint("received push notification \(rawPayload.dictionaryPayload)")
        // OpenAPI will parse your payload and play alert based on alert type.
        OpenAPI.relayPushKitNotification(dictionaryPayload: rawPayload.dictionaryPayload)
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

##### How to test <a id='test-override-dnd-ios'>
Using In-Telligent Portal:
You can use the In-Telligent portal to send notifications once section 7 (below) has been fully integrated on the In-Telligent servers.
1. Launch In-Telligent web portal
    1. Prod: https://app.in-telligent.com/
    2. Dev: https://app.uat.in-telligent.com/
2. Login using valid credentials.
3. Click on “Communities” tab from top navigation.
4. Select community from list to send alert notification.
5. Once community page is opened, click on “send a community alert” from left sidebar navigation.
6. Enter required fields, select type of alert and click on send button to send to subscribed users for selected community.
7. Alert should send to the selected/all users in community.
8. If it is critical alert(Ping, Critical, LSA,PC LSA, Weather, Lightning), it should come with VOIP call otherwise it should come with regular push notification
   Using Pusher Client
   The following approach can be used to test third-party application functionality without interaction with the In-Telligent messaging service.
   NOTE: The In-Telligent messaging service can also be used for testing purposes once the third-party application has been fully integrated with the In-Telligent backend services.  See section 7 below for more information.
1. Use Pusher client to send a notification to the device
   Ref: https://github.com/noodlewerk/NWPusher
2. Print and capture the device token from Log as soon as you run the application on the device.
3. Use this device token, select certificate related to the bundle ID and the sample payload shown below to send the notification.
4. The device will receive the alert and the respective sound. If the app developer wants to show the alert within the application, please capture the details from the payload and display accordingly.
   Sample payload: Regular Push
   ```swift
   {
    "payload_version": 2,
    "notification": {
     "id": "18049",
     "type": "normal",
     "language": "en",
     "suffix": null,
     "action": "pushNotification"
    },
    "building": {
     "id": "10097",
     "name": "Buidling name"
    },
    "topic": "com.intelligent.OpenAPIDemo",
    "aps": {
     "alert": {
      "title": "test8",
      "body": "Hola Veera. Esta es una alerta de prueba de la India. Espero que hayas recibido esto. Si usted puede leer esto. Puedes ir a Panamá."
     },
    "badge": 1,
    "mutable-content": 1,
    "sound": "default"
    }
   }
   ```

   Sample payload: VoIP Push
   ```swift
   {
   "payload_version": 2,
    "notification": {
     "id": "2776123",
     "type": "critical",
     "language": "en",
     "suffix": "to refer back to this alert or to see more information, please open the App",
     "action": "pushNotification"
    },
    "building": {
     "id": "16012",
     "name": "Building name"
    },
    "topic": "com.intelligent.OpenAPIDemo.voip",
    "aps": {
     "alert": {
      "title": "test",
      "body": "test"
     },
    "badge": 1,
    "mutable-content": 1
    }
   }
Description of the above payload parameters:
+ id: Any string. Generally, a good practice is to use the bundle ID
+ title: Title of the notification / alert
+ body: Actual content / information of the notification.
+ badge: To update batch count on the app icon
+ type: alert (Requires as type: alert)
+ Type can be one of  -
    1. life-safety
    2. personal-safety
    3. critical
    4. ping
    5. weather-alert
    6. lightning-alert
    7. pc-urgent
    8. pc-emergency
    9. Normal
    10. suggested

### Auto-subscribe (Auto grouping) to nearest communities
This feature allows the device to automatically subscribe to all the nearest In-Telligent communities. This application will run in the background and listen for the device location change events and auto-subscribe or un-subscribe to respective communities.
The Auto-subscribe functionality triggers in two scenarios:
 1. **User moves away from Geo-fence range:** OpenAPI will un-subscribe the user from community.
 2. **User comes into a Geo-fence range:** OpenAPI will subscribe the user to the community.
 
#### iOS <a id='auto-subscribe-ios'></a>
The auto subscription feature will subscribe or un-subscribe a device based on device location change events.  Once this functionality has been invoked, every user / device will automatically update into or out of In-Telligent communities when entering or leaving a Geo fence.
To implement this functionality, the following steps must be taken.
1. Auto Subscription: After authentication, the following method is used to initiate the auto subscription process:
   OpenAPI.start(self)
   This will handle the following functionality:
    1. Handling location change Events:
        1. Get the device location and listen for subsequent location change events.
        2. Automatically add / remove Geo fence boundaries to / from the device.
    2. Get communities and subscribe to new communities list from server.
        1. Get list of communities from In-Telligent server API.
        2. Auto subscribe to the received communities from API.
        3. Save received communities into device local storage (DB).
           The above method is to be called after authorization and whenever app needs to start Auto-Subscription.
2. Community lists for a subscriber:
   After auto subscription has been invoked, handle delegate method - subscribedCommunities( ) – to get a list of all communities that a device has been auto subscribed.  The following is a code snippet for this method:
   ```swift
       public static func getSubscribedCommunities() -> [INCommunity] {
        INCommunityManager.shared.getSubscribedCommunities()
    }
   ```
3. Permissions:
   Add following permissions to. plist.
    ```swift
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
   
##### How to test <a id='test-auto-subscribe-ios'></a>
1. Install and open the sample application.
2. A list of communities (nearby) for which the device is subscribed will be shown. As this auto-subscription is based on the user’s geo location, it shows different results in different locations. If there are no communities near to the user, the device will not be subscribed to any communities.
3. To add new communities for testing purposes:
    1. Launch In-Telligent web portal
        1. Prod: https://app.in-telligent.com/
        2. Dev: https://app.uat.in-telligent.com/
    2. Login using valid credentials.
    3. Click on “Communities” tab from top navigation.
    4. Click on “Add New community” from top navigations.
    5. Fill required fields and click on Save button.
    6. After saving user will navigate to community summary page where user can edit any fields if required.
    7. Newly
   
### Language translation
This feature translates the alert message to any available language.
Note: List of languages will be coming from the In-Telligent.

#### iOS <a id='language-translation-ios'></a>
The language translation feature will translate community notifications from the original language to any other supported language.
To implement this functionality, the following steps must be taken.
1. Building Notifications: After authentication and getting buildings the following method is used to get notifications for buildings using “building id”.
   OpenAPI.getBuildingNotifications()
2. Notifications for building: After authentication and getting buildings the following method is used to get notifications for a single building according to building ID.
   OpenAPI.getNotificationsByBuilding(communityId)
3. Notifications: After authentication and getting buildings the following method is used to get complete notification data according to notification ID.
   OpenAPI.getCompleteNotification()
   ```swift
         OpenAPI.getCompleteNotification(inNotification, inNotification.id) { notification in
                completionCallBack(true, "")
        } failure: { error, responseCode in
            completionCallBack(false, error?.localizedDescription ?? "Something went Wrong")
        }
   ```
4. List of Languages: After getting building notifications, the following method is used to get a list of languages supported for Notification translation.
   INLanguageManager.getLanguages()
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
5. Notification Translation: The method INLanguageManager.getTranslation() is used to retrieve the translated message and the title of the message.
   Parameters: notification ID and target language.
   INLanguageManager.getTranslation()
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
   
##### How to test <a id='test-language-translation-ios'></a>
Testing can be done using the sample application that was shared as part of the build files.

### Send alerts to all subscribers
A Community manager can initiate this API to send community alert to subscribers of his community. This will allow us to send different types of alerts (Regular, Personal, Ping, Critical, LSA) with or without attachments from the mobile app.
**Note: (To become a community manager for any given community, you need to contact admin)**
Admin can add a Community Manager in In-Telligent Web Portal. To register as a Manager, a valid email id / mobile number required. Once Admin adds a Community Manager for any given community, he will receive a link to set password. After setting the password, with that credentials Community Manager can login to the Mobile app.

#### iOS <a id='send-alerts-ios'></a>
A Community manager can initiate this API to send community alert to subscribers of his community. This will allow us to send different types of alerts (Regular, Personal, Ping, Critical, LSA) with or without attachments from the mobile app.
To implement this functionality, the following steps must be taken.
**Note: (To become a community manager for any given community, you need to contact admin)**
Admin can add a Community Manager in In-Telligent Web Portal. To register as a Manager, a valid email id / mobile number required. Once Admin adds a Community Manager for any given community, he will receive a link to set password. After setting the password, with that credentials Community Manager can login to the Mobile app.
   1. Send Alert: After authentication with community manager credentials, you will be able to access the below API call with the necessary information.
      OpenAPI.sendAlert(title: alertTitle, message: alertMessage, building: buildingInformation, attachments: attachmentsInformation, notificationType: NotificationType)
      **Parameters:**
      **title –**
      Required - Yes
      Type - String
      **message –**
      Required - Yes
      Type - String
      **building –**
      Required - Yes
      Type – INBuilding (OpenAPI library class)
      **attachments –**
      Required – Yes
      Type – Array of CustomImage (OpenAPI library class)
      **notificationType –**
      Required – Yes
      Type – NotificationType (OpenAPI library class)
      ```swift
      OpenAPI.sendAlert(title: title_value, message: message_value, building: building, attachments: attachments, notificationType: notification_type, success: {
       // Handle success response
      }) { (error) in
       // Handle error response
      }
      ```

##### How to test <a id='test-send-alerts-ios'></a>
Testing can be done using the sample application that was shared as part of the build files. In Web portal we can verify it under community details in – View Sent Out Alerts
   
### Delivered alert status of an alert
The delivered alert status feature will inform the server about notification being delivered to the user. It will be done without developer's action on receiving an alert.

### Opened alert status
The opened alert status feature will inform the server about notification being read by the user.

#### iOS <a id='alert-opened-ios'></a>
To implement this functionality, the following steps must be taken 
1. Opened Alert: After authentication with community manager credentials, you will be able to access the below API call with the necessary information.
   OpenAPI.openedAlert(notificationId: notification_id)
   **Parameters:**
   **notificationId –**
   Required - Yes
   Type – Int
   ```swift
          if let notification = notification {
            API.markOpened(notification, success: nil, failure: nil)
            self.getNotificationInfoCall(innotifcation: notification)
        }
   ```

### Delete an alert
The delete alert feature will enable a user to delete an alert.
   
#### iOS <a id='delete-alert-ios'></a>
To implement this functionality, the following steps must be taken
   1. Delete Alert: We are deleting the alert locally which is stored by the Realm.
   ```swift
           Realm.write { (blockRealm) in
            blockRealm.delete(self)
        }
   ```

## Integration with In-Telligent
Any partner application is required to integrate with In-Telligent systems to maintain user authentication and to send notifications from In-Telligent portals.
In order to integrate, the following details have to be shared with the In-Telligent development team. Once the In-Telligent development team receives the information, it may take up to two days to integrate with In-Telligent systems.
   1. iOS<br>
      To send Apple PushKit notifications from the In-Telligent portal, your application’s certificates are required.
         1. Generate a P12 file in KEYS section in the Apple developer portal.
         2. Download the generated file.
         3. Share the file with the In-Telligent development team.

## References
   2. https://chrome.google.com/webstore/detail/restlet-client-rest-api-t/aejoelaoggembcahagimdiliamlcdmfm?hl=en
   3. https://console.firebase.google.com
   4. https://firebase.google.com/docs/cloud-messaging/server

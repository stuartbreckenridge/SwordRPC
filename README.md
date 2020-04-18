# SwordRPC - A Discord Rich Presence Library for Swift

[![Swift Version](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat-square)](https://swift.org) [![Tag](https://img.shields.io/github/tag/Azoy/SwordRPC.svg?style=flat-square&label=release&colorB=)](https://github.com/Azoy/SwordRPC/releases)

## Changes in this fork
- Added a `disconnect()` function
  - There seems to be an issue with re`connect()`ing after a `disconnect()`
  - Workaround is to just create a new `SwordRPC` object
- Changed timestamps to use integer seconds
  - The Discord API expects timestamps to be integer, and will behave strangely if passed a non-integer value
- Presence update requests to the API are made when the presence is changed, instead of every 15 seconds
  - Presence updates on startup are now much faster
  - The Discord API handles the 15 second update frequency limit for us
- Updated some deprecated functions for compatibility with Swift 5
- Fixed a crash that would occur upon connecting to the Discord API

## Requirements
1. macOS, Linux
2. Swift 4.0

## Adding SwordRP
### CocoaPods
Edit your Podfile to add this dependency:

```ruby
platform :osx, '10.11'

target 'yourappnamehere' do
  use_frameworks!
  pod 'SwordRPC'
end
```

## Example
### Callbacks
```swift
import SwordRPC

/// Additional arguments:
/// handlerInterval: Int = 1000 (decides how fast to check discord for updates, 1000ms = 1s)
/// autoRegister: Bool = true (automatically registers your application to discord's url scheme (discord-appid://))
/// steamId: String? = nil (this is for steam games on these platforms)
let rpc = SwordRPC(appId: "123")

rpc.onConnect { rpc in
  var presence = RichPresence()
  presence.details = "Ranked | Mode: \(mode)"
  presence.state = "In a Group"
  presence.timestamps.start = Date()
  presence.timestamps.end = Date() + 600 // 600s = 10m
  presence.assets.largeImage = "map1"
  presence.assets.largeText = "Map 1"
  presence.assets.smallImage = "character1"
  presence.assets.smallText = "Character 1"
  presence.party.max = 5
  presence.party.size = 3
  presence.party.id = "partyId"
  presence.secrets.match = "matchSecret"
  presence.secrets.join = "joinSecret"
  presence.secrets.joinRequest = "joinRequestSecret"

  rpc.setPresence(presence)
}

rpc.onDisconnect { rpc, code, msg in
  print("It appears we have disconnected from Discord")
}

rpc.onError { rpc, code, msg in
  print("It appears we have discovered an error!")
}

rpc.onJoinGame { rpc, secret in
  print("We have found us a join game secret!")
}

rpc.onSpectateGame { rpc, secret in
  print("Our user wants to spectate!")
}

rpc.onJoinRequest { rpc, request, secret in
  print("Some user wants to play with us!")
  print(request.username)
  print(request.avatar)
  print(request.discriminator)
  print(request.userId)

  rpc.reply(to: request, with: .yes) // or .no or .ignore
}

rpc.connect()
```

### Delegation
```swift
import SwordRPC

class ViewController {
  override func viewDidLoad() {
    let rpc = SwordRPC(appId: "123")
    rpc.delegate = self
    rpc.connect()
  }
}

extension ViewController: SwordRPCDelegate {
  func swordRPCDidConnect(
    _ rpc: SwordRPC
  ) {}

  func swordRPCDidDisconnect(
    _ rpc: SwordRPC,
    code: Int?,
    message msg: String?
  ) {}

  func swordRPCDidReceiveError(
    _ rpc: SwordRPC,
    code: Int,
    message msg: String
  ) {}

  func swordRPCDidJoinGame(
    _ rpc: SwordRPC,
    secret: String
  ) {}

  func swordRPCDidSpectateGame(
    _ rpc: SwordRPC,
    secret: String
  ) {}

  func swordRPCDidReceiveJoinRequest(
    _ rpc: SwordRPC,
    request: JoinRequest,
    secret: String
  ) {}
}
```

## Links
Join the [API Channel](https://discord.gg/99a3xNk) to ask questions!

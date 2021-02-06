# Perseus


## Unlock iPhone with Apple Watch

iPhone can use your Apple Watch to unlock when Face ID detects a face with a mask. Your Apple Watch must be nearby, on your wrist, unlocked, and protected by a passcode. Your iPhone must be unlocked with passcode once after these criterion are met.<br/>

----------

This feature was seen implemented by Apple is iOS 14.5 beta.1.


## So, how does it works?
Only on iOS 13.5, Face ID able to detect if you're wearing a mask, and Persues will try to check for the criterion mentioned above for authentication using your Apple Watch. 

----------

**What if my dog is wearing a mask, and I'm near him?**

----------

It'll still try to authenticates with your Apple Watch, given your dog is on your lap, your dog will probably able to snoop your phone (hide that cookie picture!). It can detects a face with a mask, but not who it belong to. I think Apple's current implementation also facing this issue, as can be seen on r/iOSBeta. I'm sure Apple's implementation will gets better over time.

----------

**What if I don't wear a mask?**

----------

Bad boy! Wear a mask! On the serious note, iOS 13.5 and above **will not** use your Apple Watch to authenticated. Lower iOS version will (that's the con of this tweak on lower iOS version).

----------

**How near is near?**

----------

By default, it's less than 1 meter, which is around -60 RSSI (you can adjust this in settings).

----------

**Why do I need to enter my passcode once?**

----------

Perseus will encrypt your passcode with AES256 (see the source code) for the first time, and will use it to unlock your iPhone for later. This "token" as I would like to call it, will be revoked if your Apple Watch is no longer authenticated (taken off your wrist or no longer unlocked). You'll have to do this every-time your Apple Watch is no longer authenticated for security concern. It's not saved locally your device. You'll probably not even notice this if you're a person where you wear the watch all the time. Also, this is a limitation due to how we're unable to access SEPOS. So it's as good as it can be.

----------

**What if I take the Apple Watch off the wrist while iPhone is unlocked?**

----------

It'll automatically lock your iPhone, configurable in settings.

----------

**How about iOS version lower than 13.5?**

----------


For iOS version lower than that, it'll automatically fall to Apple Watch authentication when your face is in view. All those conditions above still apply, except the face mask bit.

----------

**Will it works with TouchID devices?**

----------

NO.
## Compatibility
Support X series iPhone on iOS 13+. This package tested to be working on iPhone X iOS 13.5, and with Apple Watch S5 on watchOS 6.2.8. Might or might not work on different combinations.

## License
All source code in this repository are licensed under GPLv3, unless stated otherwise.

----------

Copyright (c) 2021 udevs
# flutter_sodium

With flutter_sodium you get access to the modern, easy-to-use [libsodium](https://download.libsodium.org/doc/) crypto library in your [Flutter](https://flutter.io) apps. One set of crypto APIs supporting both Android and iOS.

[![Pub](https://img.shields.io/pub/v/flutter_sodium.svg)](https://pub.dartlang.org/packages/flutter_sodium)

## Getting Started

In your flutter project add the dependency:

```yml
dependencies:
  ...
  flutter_sodium: any
```

__Important:__ For iOS you'll need to [manually update](https://github.com/firstfloorsoftware/flutter_sodium/issues/1#issuecomment-403973858) the Podfile in your ios project.

## Usage example

```dart
import 'package:flutter_sodium/flutter_sodium.dart';

// Password hashing (using Argon)
final password = 'my password';
final str = await PasswordHash.hashStorage(password);

print(str);

// verify hash str
final valid = await PasswordHash.verifyStorage(str, password);

assert(valid);
```

This project includes an extensive example app with runnable code samples. Be sure to check it out!

<img src="https://raw.githubusercontent.com/firstfloorsoftware/flutter_sodium/develop/example/assets/screenshots/screenshot1.png" width="300">

## API coverage
The flutter_sodium plugin implements the following libsodium APIs *):
- crypto_aead
- crypto_auth
- crypto_box
- crypto_generichash
- crypto_kdf
- crypto_kx
- crypto_onetimeauth
- crypto_pwhash
- crypto_scalarmult
- crypto_secretbox
- crypto_shorthash
- crypto_sign
- randombytes
- sodium_version

*) Some APIs are not available on Android. See [this issue](https://github.com/firstfloorsoftware/flutter_sodium/issues/7) for details.

## Dart APIs
The plugin includes a core API that maps native libsodium functions 1:1 to Dart equivalents. The core API is available in the class [`Sodium`](https://github.com/firstfloorsoftware/flutter_sodium/blob/master/lib/flutter_sodium.dart). Dart naming conventions are used for core API function names. A native libsodium function such as `crypto_pwhash_str`, is available in flutter as `Sodium.cryptoPwhashStr`.

Also included in flutter_sodium is a high-level, opinionated API providing access to libsodium in a Dart friendly manner. The various functions are available in separate Dart classes. Password hashing for example is available in the `PasswordHash` class. The high-level API depends on the core API to get things done.

## Threading
The flutter_sodium APIs can be executed on the UI thread, or on a background thread. Most crypto tasks can safely run on the UI thread, some tasks take considerable time to execute (most notable crypto_pwhash_* ), and will run on a background thread by default. All methods of the core API includes an optional ```useBackgroundThread``` argument to switch from UI to background thread or vice versa. Background execution is implemented using ```AsyncTask``` in Android, and ```DispatchQueue``` in iOS.

Please note that the entire API is asynchronous. Even when a crypto task is executed on the UI thread, the method returns an async ```Future``` which needs to be awaited.

## Current issues
- Some APIs are not available on Android. An issue has been created with the [complete list](https://github.com/firstfloorsoftware/flutter_sodium/issues/7).
- Using flutter_sodium in iOS doesn't work right out of the box. [Manual installation](https://github.com/firstfloorsoftware/flutter_sodium/issues/1#issuecomment-403973858) steps are required.
- Since Flutter does [not support native binaries](https://github.com/flutter/flutter/issues/7053), a [platform channel](https://flutter.io/platform-channels/) is established to enable native function invocation. One side effect of this approach is that the entire flutter_sodium API is asynchronous. This is great for potential long-running operations such as Argon password hashing, but does not make much sense for other short-running functions.
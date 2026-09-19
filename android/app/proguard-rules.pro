# Flutter's own classes are kept by the engine's consumer rules; this file
# holds only what this application adds.

# flutter_secure_storage relies on AndroidX Security, which reflects over
# these classes when opening the keystore-backed preferences.
-keep class androidx.security.crypto.** { *; }
-keep class com.google.crypto.tink.** { *; }

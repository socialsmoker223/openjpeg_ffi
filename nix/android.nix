{ androidenv }:

androidenv.composeAndroidPackages {
  includeEmulator = false;
  buildToolsVersions = [ "30.0.3" ];
  platformVersions = [ "29" "30" "31" "32" "33" ];
  includeSources = false;
  includeSystemImages = false;
  systemImageTypes = [ "google_apis_playstore" ];
  abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
  includeNDK = true;
  ndkVersion = "23.1.7779620";
  cmakeVersions = [ "3.18.1" ];
  useGoogleAPIs = true;
  useGoogleTVAddOns = false;
}

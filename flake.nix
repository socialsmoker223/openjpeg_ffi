{
  description = "An example project using flutter";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.android_sdk.accept_license = true;
        };
      in {
        devShells.default =
          let android = pkgs.callPackage ./nix/android.nix { };
          in pkgs.mkShell {
            buildInputs = with pkgs; [
              # from pkgs
              flutter
              jdk17
              #from ./nix/*
              android.platform-tools
              cmake
              openjpeg
              clang-tools
              llvm

            ];

            ANDROID_HOME = "${android.androidsdk}/libexec/android-sdk";
            ANDROID_SDK_ROOT = "${android.androidsdk}/libexec/android-sdk";
            ANDROID_NDK = "${android.androidsdk}/libexec/android-sdk/ndk-bundle";
            JAVA_HOME = pkgs.jdk17;
            OPENJPEG_INCLUDE_DIRS = "${pkgs.openjpeg}/lib";
            OPENJPEG_DIRS = "${pkgs.openjpeg}/lib";
            LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
            shellHook = ''
              export PATH="${android.androidsdk}/libexec/android-sdk/cmake/3.21.1/bin:$PATH"
            '';
          };
      });
}

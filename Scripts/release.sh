VERSION="$1"
PREFIXED_VERSION="v$1"

sed -i '' 's/NSString \*const kMParticleSDKVersion = @".*/NSString *const kMParticleSDKVersion = @"'"$VERSION"'";/' mParticle-Apple-SDK/MPIConstants.m
/usr/libexec/PlistBuddy -c "Set CFBundleShortVersionString $VERSION" Framework/Info.plist
jq --indent 3 '. += {'"\"$VERSION\""': "'"https://github.com/mParticle/mparticle-apple-sdk/releases/download/$PREFIXED_VERSION/mParticle_Apple_SDK.framework.zip"'"}' mParticle_Apple_SDK.json > tmp.json
mv tmp.json mParticle_Apple_SDK.json
sudo npm install -g podspec-bump
podspec-bump -w -i $VERSION

./Scripts/make_artifacts.sh
ls mParticle_Apple_SDK.framework.zip mParticle_Apple_SDK.framework.nolocation.zip mParticle_Apple_SDK.xcframework.zip mParticle_Apple_SDK.xcframework.nolocation.zip generated-docs.zip || exit 1

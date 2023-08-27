test:
	@echo "╠ Running test..."
	flutter test

deploy-android:
	@echo "╠ Sending Android Build to Closed Testing..."
	cd android && bundle install
	cd android/fastlane && bundle exec fastlane deploy

deploy-web:
	@echo "╠ Sending Build to Firebase Hosting..."
	flutter build web --no-tree-shake-icons
	firebase deploy

deploy: test deploy-android deploy-web

.PHONY: test deploy-android deploy-web

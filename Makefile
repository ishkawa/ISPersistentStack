test:
	xcodebuild \
		-sdk iphonesimulator \
		-workspace ISPersistentStack.xcworkspace \
		-scheme UnitTests \
		-configuration Debug \
		clean test \
		TEST_AFTER_BUILD=YES \
		ONLY_ACTIVE_ARCH=NO \
		GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
		GCC_GENERATE_TEST_COVERAGE_FILES=YES

coveralls:
	coveralls -e UnitTests -e DemoApp


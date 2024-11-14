def get_versions 
  version = get_version_number(target: ENV["SCO_TARGET_NAME"])
  build_number = latest_testflight_build_number(version: version)
  return version, build_number
end

private_lane :update_build_number do
  version, build_number = get_versions

  UI.message "Xcode project version: #{version}"
  UI.message "TestFlight build number #{build_number}"

  build_number += 1

  UI.message "Incremented TestFlight build number #{build_number}"

  increment_build_number(build_number: build_number)
end

private_lane :add_version_git_tag do
  add_git_tag(tag: "testflight-#{lane_context[SharedValues::LATEST_TESTFLIGHT_VERSION]}.#{lane_context[SharedValues::LATEST_TESTFLIGHT_BUILD_NUMBER] + 1}")
  push_git_tags
end

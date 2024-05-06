def get_versions 
  version = get_version_number(target: ENV["SCO_TARGET_NAME"])
  build_number = latest_testflight_build_number(version: version)
  return version, build_number
end

private_lane :handle_version do
  version, build_number = get_versions
  increment_testflight_build_number(build_number: build_number)
  add_version_git_tag(version: version, build_number: build_number)
end

private_lane :increment_testflight_build_number do |values|
  increment_build_number(build_number: values[:build_number])
end

private_lane :add_version_git_tag do |values|
  add_git_tag(tag: "testflight-#{values[:version]}.#{values[:build_number]}")
  push_git_tags
end

Pod::Spec.new do |s|
    s.name = "Formalist"
    s.version = "0.6.3"
    s.license = { type: "MIT" }
    s.homepage = "https://github.com/seedco/Formalist"
    s.author = "Seed"
    s.summary = "Declarative form building framework for iOS"
    s.description = "Swift framework for building forms on iOS using a simple, declarative, and readable syntax"
    s.source = {
      git: "https://github.com/seedco/Formalist.git",
      tag: s.version.to_s
    }
    s.source_files = "Formalist/*.swift"
    s.ios.deployment_target = "9.0"
    s.frameworks = "UIKit"
    s.dependency "SeedStackViewController", "~> 0.5.0"
    s.swift_versions = "5.0"
end

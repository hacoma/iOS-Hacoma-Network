Pod::Spec.new do |s|
  s.name = 'HacomaNetwork'
  s.version = '1.0.2'
  s.license = { :type => 'MIT' }
  s.homepage = 'https://github.com/hacoma/iOS-HacomaNetwork'
  s.authors = { 'hacoma' => 'hacoma92@gmail.com' }
  s.summary = 'Network for iOS application'
  s.swift_version = '5.0'

  s.ios.deployment_target = '11.0'

  s.source = { :git => 'https://github.com/hacoma/iOS-HacomaNetwork.git', :tag => s.version }
  s.source_files = 'HacomaNetwork/Module/Source/*.swift'

  s.dependency 'Moya', '14.0.0'
end

Pod::Spec.new do |s|

  s.name         = "LJMVVMTool"

  s.version      = "0.0.4"

  s.summary      = "基于RAC实现响应式编程的工具类."

  s.homepage     = "https://github.com/LJMagicCoder"

  s.license      = "Apache License, Version 2.0"

  s.author       = { "LJMagicCoder" => "582494319@qq.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/LJMagicCoder/LJMVVMTool.git", :tag => s.version }

  s.source_files  = "LJMVVMTool", "LJMVVMTool/**/*.{h,m}"

  s.exclude_files = "LJMVVMTool/Exclude"

  s.requires_arc = true

  s.dependency "ReactiveObjC", "~> 3.0.0"

end

class Mvnvm < Formula
  desc "Maven version manager"
  homepage "https://mvnvm.org/"
  url "https://bitbucket.org/mjensen/mvnvm/get/mvnvm-1.0.15.tar.gz"
  sha256 "2d2163b89d918e07146131407751eb7aff9c5fb5ae8c954b912e60860fb1c8ea"
  license "Apache-2.0"
  head "https://bitbucket.org/mjensen/mvnvm.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "d302f0e086f47adc21c6c401b1ab6fab48ab5c9bbf82459c94c886a07b8a5b8c"
  end

  depends_on "openjdk"

  conflicts_with "maven", because: "also installs a 'mvn' executable"

  def install
    bin.install "mvn"
    bin.install "mvnDebug"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"settings.xml").write <<~EOS
      <settings><localRepository>#{testpath}/repository</localRepository></settings>
    EOS
    (testpath/"mvnvm.properties").write <<~EOS
      mvn_version=3.5.2
    EOS
    (testpath/"pom.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <project xmlns="https://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="https://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <groupId>org.homebrew</groupId>
        <artifactId>maven-test</artifactId>
        <version>1.0.0-SNAPSHOT</version>
        <properties>
         <maven.compiler.source>1.7</maven.compiler.source>
         <maven.compiler.target>1.7</maven.compiler.target>
        </properties>
      </project>
    EOS
    (testpath/"src/main/java/org/homebrew/MavenTest.java").write <<~EOS
      package org.homebrew;
      public class MavenTest {
        public static void main(String[] args) {
          System.out.println("Testing Maven with Homebrew!");
        }
      }
    EOS
    system "#{bin}/mvn", "-gs", "#{testpath}/settings.xml", "compile"
  end
end

require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.2.0.tgz"
  sha256 "0e41b6df81b46449390ef3bbf4f27ce2ffdd1af4a29f1174f1564afb3d2725d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a33a21cfdd6ca4952dfbfa16d965b185cac5db2608db1f3a83bce0bfb483863e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a33a21cfdd6ca4952dfbfa16d965b185cac5db2608db1f3a83bce0bfb483863e"
    sha256 cellar: :any_skip_relocation, monterey:       "e5a4e9f2b9f83022e5f860e4561f4ac5dca4a183a631c8ad7b54e56cbf8f3017"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5a4e9f2b9f83022e5f860e4561f4ac5dca4a183a631c8ad7b54e56cbf8f3017"
    sha256 cellar: :any_skip_relocation, catalina:       "e5a4e9f2b9f83022e5f860e4561f4ac5dca4a183a631c8ad7b54e56cbf8f3017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a33a21cfdd6ca4952dfbfa16d965b185cac5db2608db1f3a83bce0bfb483863e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end

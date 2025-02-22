class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.4.3/phpstan.phar"
  sha256 "c9a622eb81ae4b9aabdfdb6cba8b7bc3f5d3fc5ee79c0407b0d16203895b8702"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a910ff852d08f31851874b1e1ced5a863bdb9fa7b3068d4239dcd450875d80f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a910ff852d08f31851874b1e1ced5a863bdb9fa7b3068d4239dcd450875d80f8"
    sha256 cellar: :any_skip_relocation, monterey:       "2b1a5a3edbbfc34bbef645b36172ee1a64c3fee1a5a07bae2f665a7120c832fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b1a5a3edbbfc34bbef645b36172ee1a64c3fee1a5a07bae2f665a7120c832fb"
    sha256 cellar: :any_skip_relocation, catalina:       "2b1a5a3edbbfc34bbef645b36172ee1a64c3fee1a5a07bae2f665a7120c832fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a910ff852d08f31851874b1e1ced5a863bdb9fa7b3068d4239dcd450875d80f8"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
  end

  def install
    bin.install "phpstan.phar" => "phpstan"
  end

  test do
    (testpath/"src/autoload.php").write <<~EOS
      <?php
      spl_autoload_register(
          function($class) {
              static $classes = null;
              if ($classes === null) {
                  $classes = array(
                      'email' => '/Email.php'
                  );
              }
              $cn = strtolower($class);
              if (isset($classes[$cn])) {
                  require __DIR__ . $classes[$cn];
              }
          },
          true,
          false
      );
    EOS

    (testpath/"src/Email.php").write <<~EOS
      <?php
        declare(strict_types=1);

        final class Email
        {
            private string $email;

            private function __construct(string $email)
            {
                $this->ensureIsValidEmail($email);

                $this->email = $email;
            }

            public static function fromString(string $email): self
            {
                return new self($email);
            }

            public function __toString(): string
            {
                return $this->email;
            }

            private function ensureIsValidEmail(string $email): void
            {
                if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                    throw new InvalidArgumentException(
                        sprintf(
                            '"%s" is not a valid email address',
                            $email
                        )
                    );
                }
            }
        }
    EOS
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end

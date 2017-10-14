class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  head "https://github.com/universal-ctags/ctags.git"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson" => :optional
  depends_on "libyaml" => :optional
  conflicts_with "ctags", :because => "this formula installs the same executable as the ctags formula"

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_path "PATH", libexec/"vendor/bin"

    resource("docutils").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
      Under some circumstances, emacs and ctags can conflict. By default,
      emacs provides an executable `ctags` that would conflict with the
      executable of the same name that ctags provides. To prevent this,
      Homebrew removes the emacs `ctags` and its manpage before linking.
      However, if you install emacs with the `--keep-ctags` option, then
      the `ctags` emacs provides will not be removed. In that case, you
      won't be able to install ctags successfully. It will build but not
      link.
    EOS
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <stdlib.h>

      void func()
      {
        printf("Hello World!");
      }

      int main()
      {
        func();
        return 0;
      }
    EOS
    system "#{bin}/ctags", "-R", "."
    assert_match /func.*test\.c/, File.read("tags")
  end
end

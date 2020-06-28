class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  head "https://github.com/universal-ctags/ctags.git"
  option "without-xml", "Compile without libxml2"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "docutils" => :recommended
  depends_on "jansson" => :optional
  depends_on "libyaml" => :optional
  conflicts_with "ctags", :because => "this formula installs the same executable as the ctags formula"

  def install
    opts = []
    opts << "--disable-xml" if build.without? "xml"
    opts << "PYTHON_EXTRA_LDFLAGS=#{`#{Formula["python@3.8"].opt_bin}/python3-config --ldflags`.chomp}" if OS.linux?
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", *opts
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
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
    (testpath/"test.c").write <<~EOS
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

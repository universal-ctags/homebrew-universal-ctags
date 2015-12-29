class UniversalCtags < Formula
  homepage 'https://github.com/universal-ctags/ctags'
  head 'https://github.com/universal-ctags/ctags.git'

  option "without-iconv", "Enable multibyte character encoding"
  option "without-macro-patterns", "Disable patterns as default method to locate macros and instead use line numbers"

  depends_on :autoconf
  depends_on :automake

  conflicts_with 'ctags', :because => 'this formula installs the same executable as the ctags formula'

  def install
    args = %W[
      --prefix=#{prefix}
    ]

    args << "--enable-iconv" if build.with? "iconv"
    args << "--enable-macro-patterns" if build.with? "macro-patterns"
    system "./autogen.sh"
    system "./configure", *args
    system "make install"
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

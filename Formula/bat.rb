class Bat < Formula
  desc "Bayesian analysis toolkit"
  homepage "http://mpp.mpg.de/bat"
  url "https://github.com/bat/bat/releases/download/v1.0.0-RC1/BAT-1.0.0-RC1.tar.gz"
  sha256 "1438b6a7e1be6093139d539ea9c14f2be36061d45412e2b28c52c04fcc33f463"

  option "with-parallel", "Enable internal parallelization with OpenMP"
  option "with-roostats", "Compile with RooStats support"

  depends_on "root"
  if build.with? "parallel"
    depends_on "cuba" => :recommended
  else
    depends_on "cuba" => :keg_only
  end

  def install
    opts = ["--prefix=#{prefix}"]

    opts << "--enable-parallel" if build.with? "parallel"
    opts << "--enable-roostats" if build.with? "roostats"

    if build.without? "cuba"
        opts << "--with-cuba=no"
    else
        opts << "--with-cuba"
    end

    system "./configure", *opts
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test bat`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end

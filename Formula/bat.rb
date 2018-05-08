class Bat < Formula
  desc "Bayesian analysis toolkit"
  homepage "http://mpp.mpg.de/bat"
  url "https://github.com/bat/bat/releases/download/v1.0.0-RC1/BAT-1.0.0-RC1.tar.gz"
  sha256 "1438b6a7e1be6093139d539ea9c14f2be36061d45412e2b28c52c04fcc33f463"

  depends_on "root"
  depends_on "cuba" => :recommended

  option "multithreading", "Enable OpenMP multithreading support (gcc only)" if OS.linux?

  def install
    opts = [
      "--prefix=#{prefix}"
    ]

    if build.without? "cuba"
        opts << "--with-cuba=no"
    else
        opts << "--with-cuba"
    end

    if build.with?("multithreading") && OS.mac?
      odie "Multithreading support is not available on OSX for this formula"
    end

    opts << "--enable-parallel" if build.with? "multithreading"

    system "./configure", *opts
    system "make", "install"
    (share/"BAT/examples").install Dir["examples/basic"]
    (share/"BAT/examples").install Dir["examples/advanced"]
    (share/"BAT").install Dir["doc"]
  end

  test do
      system "#{prefix}/share/BAT/examples/basic/binomial/runEfficiency"
  end
end

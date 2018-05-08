class Bat < Formula
  desc "Bayesian analysis toolkit"
  homepage "http://mpp.mpg.de/bat"
  url "https://github.com/bat/bat/releases/download/v1.0.0-RC2/BAT-1.0.0-RC2.tar.gz"
  sha256 "51267cb1851d56858c44568a3029047ad9a3f76fbe2d58872bc78b7610d225b6"

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

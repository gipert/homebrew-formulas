class Geant4 < Formula
  desc "Simulation toolkit for particle transport through matter"
  homepage "http://geant4.web.cern.ch"
  url "http://cern.ch/geant4-data/releases/geant4.10.04.p01.tar.gz"
  version "10.4.1"
  sha256 "a3eb13e4f1217737b842d3869dc5b1fb978f761113e74bd4eaf6017307d234dd"

  option "with-gdml",          "Build with GDML support"
  option "with-g3tog4",        "Build the G3ToG4 library"
  option "with-multithreaded", "Build with multithreading support"
  option "without-opengl",     "Do not build the X11 OpenGL visualization driver"
  option "without-raytracer",  "Do not build RayTracer visualization driver with X11 support"
  option "with-qt",            "Build Qt4/5 User Interface and Visualization drivers"
  option "with-openmotif",     "Build Motif User Interface and Visualization drivers"

  depends_on "cmake"     => :build
  depends_on "clhep"
  depends_on "qt"        => :optional
  depends_on "openmotif" => :optional
  depends_on "freetype"  => :optional
  depends_on "xerces-c" if build.with? "gdml"
  depends_on :x11       if build.with? "opengl"    => :recommended
  depends_on :x11       if build.with? "raytracer" => :recommended

  depends_on "linuxbrew/xorg/glu" unless OS.mac?

  needs :cxx11

  resource "G4NDL" do
    url "http://geant4-data.web.cern.ch/geant4-data/datasets/G4NDL.4.5.tar.gz"
    sha256 "cba928a520a788f2bc8229c7ef57f83d0934bb0c6a18c31ef05ef4865edcdf8e"
  end

  resource "G4EMLOW" do
    url "http://geant4-data.web.cern.ch/geant4-data/datasets/G4EMLOW.7.3.tar.gz"
    sha256 "583aa7f34f67b09db7d566f904c54b21e95a9ac05b60e2bfb794efb569dba14e"
  end

  resource "PhotonEvaporation" do
    url "http://geant4-data.web.cern.ch/geant4-data/datasets/G4PhotonEvaporation.5.2.tar.gz"
    sha256 "83607f8d36827b2a7fca19c9c336caffbebf61a359d0ef7cee44a8bcf3fc2d1f"
  end

  resource "RadioactiveDecay" do
    url "http://geant4-data.web.cern.ch/geant4-data/datasets/G4RadioactiveDecay.5.2.tar.gz"
    sha256 "99c038d89d70281316be15c3c98a66c5d0ca01ef575127b6a094063003e2af5d"
  end

  resource "G4NEUTRONXS" do
    url "http://geant4-data.web.cern.ch/geant4-data/datasets/G4NEUTRONXS.1.4.tar.gz"
    sha256 "57b38868d7eb060ddd65b26283402d4f161db76ed2169437c266105cca73a8fd"
  end

  resource "G4PII" do
    url "http://cern.ch/geant4-data/datasets/G4PII.1.3.tar.gz"
    sha256 "6225ad902675f4381c98c6ba25fc5a06ce87549aa979634d3d03491d6616e926"
  end

  resource "RealSurface" do
    url "http://cern.ch/geant4-data/datasets/G4RealSurface.2.1.tar.gz"
    sha256 "2a287adbda1c0292571edeae2082a65b7f7bd6cf2bf088432d1d6f889426dcf3"
  end

  resource "G4SAIDDATA" do
    url "http://geant4-data.web.cern.ch/geant4-data/datasets/G4SAIDDATA.1.1.tar.gz"
    sha256 "a38cd9a83db62311922850fe609ecd250d36adf264a88e88c82ba82b7da0ed7f"
  end

  resource "G4ABLA" do
    url "http://cern.ch/geant4-data/datasets/G4ABLA.3.1.tar.gz"
    sha256 "7698b052b58bf1b9886beacdbd6af607adc1e099fc730ab6b21cf7f090c027ed"
  end

  resource "G4ENSDFSTATE" do
    url "http://cern.ch/geant4-data/datasets/G4ENSDFSTATE.2.2.tar.gz"
    sha256 "dd7e27ef62070734a4a709601f5b3bada6641b111eb7069344e4f99a01d6e0a6"
  end

  resource "G4TENDL" do
    url "http://cern.ch/geant4-data/datasets/G4TENDL.1.3.2.tar.gz"
    sha256 "3b2987c6e3bee74197e3bd39e25e1cc756bb866c26d21a70f647959fc7afb849"
  end

  def install
    mkdir "geant-build" do
      args = %w[
        -DGEANT4_USE_SYSTEM_CLHEP=ON
        -DGEANT4_INSTALL_EXAMPLES=ON
        -DGEANT4_INSTALL_DATA=OFF
      ]

      args << "-DGEANT4_USE_QT=ON"              if build.with? "qt"
      args << "-DGEANT4_USE_XM=ON"              if build.with? "openmotif"
      args << "-DGEANT4_USE_OPENGL_X11=ON"      if build.with? "opengl"
      args << "-DGEANT4_USE_RAYTRACER_X11=ON"   if build.with? "raytracer"
      args << "-DGEANT4_USE_G3TOG4=ON"          if build.with? "g3tog4"
      args << "-DGEANT4_USE_GDML=ON"            if build.with? "gdml"
      args << "-DGEANT4_USE_FREETYPE=ON"        if build.with? "freetype"
      args << "-DGEANT4_BUILD_MULTITHREADED=ON" if build.with? "multithreaded"

      system "cmake", "..", *args
      system "make", "install"
    end
  end

  def post_install
    resources.each do |r|
      (share/"Geant4-#{version}/data/#{r.name}#{r.version}").install r
    end
  end

  def caveats; <<~EOS
    Because Geant4 depends on several installation-dependent
    environment variables to function properly, you should
    add the following commands to your shell initialization
    script (.bashrc/.profile/etc.), or call them directly
    before using Geant4.

    For bash users:
      . #{HOMEBREW_PREFIX}/bin/geant4.sh
    For zsh users:
      pushd #{HOMEBREW_PREFIX}/bin >/dev/null; . geant4.sh; popd >/dev/null
    For csh/tcsh users:
      source #{HOMEBREW_PREFIX}/bin/geant4.csh
    EOS
  end

  test do
    system "cmake", share/"Geant4-#{version}/examples/basic/B1"
    system "make"
    (testpath/"test.sh").write <<~EOS
      . #{bin}/geant4.sh
      ./exampleB1 run2.mac
    EOS
    system "/bin/bash", "test.sh"
  end
end

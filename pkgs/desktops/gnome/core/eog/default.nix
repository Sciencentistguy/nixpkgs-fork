{ lib, stdenv
, fetchurl
, meson
, ninja
, gettext
, itstool
, pkg-config
, libxml2
, libjpeg
, libpeas
, libportal
, gnome
, gtk3
, glib
, gsettings-desktop-schemas
, adwaita-icon-theme
, gnome-desktop
, lcms2
, gdk-pixbuf
, exempi
, shared-mime-info
, wrapGAppsHook
, librsvg
, libexif
, gobject-introspection
, python3
}:

stdenv.mkDerivation rec {
  pname = "eog";
  version = "41.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-huG5ujnaz3QiavpFermDtBJTuJ9he/VBOcrQiS0C2Kk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    wrapGAppsHook
    libxml2
    gobject-introspection
    python3
  ];

  buildInputs = [
    libjpeg
    libportal
    gtk3
    gdk-pixbuf
    glib
    libpeas
    librsvg
    lcms2
    gnome-desktop
    libexif
    exempi
    gsettings-desktop-schemas
    shared-mime-info
    adwaita-icon-theme
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    description = "GNOME image viewer";
    homepage = "https://wiki.gnome.org/Apps/EyeOfGnome";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}

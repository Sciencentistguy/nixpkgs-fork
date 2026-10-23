{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  python3Packages,
  vulkan-headers,
  vulkan-loader,
  shaderc,
  lcms2,
  libGL,
  libx11,
  libunwind,
  libdovi,
  xxhash,
  fast-float,
  vulkanSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libplacebo";
  version = "7.384.0";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = "libplacebo";
    rev = "253c41be7225b53f6218ecf1101bc3484b9b4df0";
    hash = "sha256-6OVoVjI1L1VM2GzjvNLE6PxvTuwUCgQsgO+EXfplUK4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3Packages.jinja2
    python3Packages.glad2
  ];

  buildInputs = [
    shaderc
    lcms2
    libGL
    libx11
    libunwind
    libdovi
    xxhash
    vulkan-headers
  ]
  ++ lib.optionals vulkanSupport [
    vulkan-loader
  ]
  ++ lib.optionals (!stdenv.cc.isGNU) [
    fast-float
  ];

  mesonFlags = [
    (lib.mesonBool "demos" false) # Don't build and install the demo programs
    (lib.mesonEnable "d3d11" false) # Disable the Direct3D 11 based renderer
    (lib.mesonEnable "glslang" false) # rely on shaderc for GLSL compilation instead
    (lib.mesonEnable "vk-proc-addr" vulkanSupport)
    (lib.mesonOption "vulkan-registry" "${vulkan-headers}/share/vulkan/registry/vk.xml")
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.mesonEnable "unwind" false) # libplacebo doesn’t build with `darwin.libunwind`
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace 'python_env.append' '#'
  '';

  meta = {
    description = "Reusable library for GPU-accelerated video/image rendering primitives";
    longDescription = ''
      Reusable library for GPU-accelerated image/view processing primitives and
      shaders, as well a batteries-included, extensible, high-quality rendering
      pipeline (similar to mpv's vo_gpu). Supports Vulkan, OpenGL and Metal (via
      MoltenVK).
    '';
    homepage = "https://code.videolan.org/videolan/libplacebo";
    changelog = "https://code.videolan.org/videolan/libplacebo/-/tags/v${finalAttrs.version}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ ProxyVT ];
    platforms = lib.platforms.all;
  };
})

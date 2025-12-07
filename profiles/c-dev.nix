{ pkgs, commonEnv, lib }:

{
  packages = with pkgs; [
    # Compilers
    gcc
    clang

    # Build systems
    cmake
    meson
    ninja
    autoconf
    automake
    libtool

    # Debuggers
    gdb
    valgrind

    # Static analysis
    clang-tools       # clang-tidy, clang-format
    cppcheck

    # Memory debugging
    valgrind

    # Profiling
    gprof
    perf

    # Libraries (common ones)
    zlib
    openssl

    # Documentation
    man-pages
    man-pages-posix

    # Code formatting
    clang-tools

    # Language server for editor integration
    clangd

    # Additional utilities
    bear              # Generates compilation database
    ccache            # Compiler cache
  ];

  shellHook = ''
    echo "🔨 C Development Environment"
    echo "Compilers: gcc ${pkgs.gcc.version}, clang ${pkgs.clang.version}"
    echo "Build tools: cmake, meson, autotools"
    echo ""

    # Set compiler preferences
    export CC=gcc
    export CXX=g++

    # Helpful aliases
    alias ccompile='gcc -Wall -Wextra -Werror -std=c11'
    alias cdebug='gcc -g -O0 -Wall -Wextra'
    alias crelease='gcc -O3 -march=native -DNDEBUG'

    # Enable ccache
    export PATH="${pkgs.ccache}/bin:$PATH"
    export CCACHE_DIR="$HOME/.ccache"

    # GDB enhancements
    echo "set disassembly-flavor intel" > /tmp/gdbinit-$$
    export GDB_INIT="/tmp/gdbinit-$$"
    alias gdb='gdb -x $GDB_INIT'

    echo "Quick commands:"
    echo "  ccompile <file.c> -o <output>  # Strict compilation"
    echo "  cdebug <file.c> -o <output>    # Debug build"
    echo "  valgrind --leak-check=full ./program"
  '';

  env = {
    # Standard C settings
    CFLAGS = "-Wall -Wextra -std=c11";
    LDFLAGS = "";

    # Enable compiler optimizations for release
    # Users can override with cdebug alias
  };
}

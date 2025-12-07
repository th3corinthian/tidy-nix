{ pkgs, commonEnv, lib }:

{
  packages = with pkgs; [
    # Disassemblers
    radare2
    rizin          # Fork of radare2
    iaito          # GUI for radare2
    cutter         # Rizin GUI

    # Decompilers
    ghidra

    # Binary analysis
    binutils       # objdump, nm, readelf, etc.
    binwalk        # Firmware analysis

    # Hex editors
    hexedit
    okteta

    # Binary utilities
    patchelf       # Modify ELF binaries
    upx            # Binary packer/unpacker

    # File format analysis
    file

    # Architecture-specific tools
    gdb
    lldb

    # Assemblers
    nasm
    yasm

    # Binary diffing
    diffoscope

    # String extraction
    strings        # Already in binutils, but explicit
  ];

  shellHook = ''
    echo "⚙️  Disassembly & Reverse Engineering Environment"
    echo "Tools: radare2, ghidra, iaito, binutils, gdb"
    echo ""

    # Radare2 setup
    alias r2='radare2 -A'     # Auto-analyze on load
    alias r2d='radare2 -d'    # Debug mode

    # Quick disassembly aliases
    alias disasm='objdump -d -M intel'
    alias headers='readelf -h'
    alias sections='readelf -S'
    alias symbols='nm -C'

    # Ghidra helper
    echo "To run Ghidra: ghidraRun"

    # Set Intel syntax for disassembly tools
    export OBJDUMP_FLAGS="-M intel"
  '';

  env = {
    # Prefer Intel syntax
    DISASSEMBLER_SYNTAX = "intel";
  };
}

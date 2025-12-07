{ pkgs, commonEnv, lib }:

{
  packages = with pkgs; [
    # Python
    python313Packages.scapy
    pwntools
  ];

  shellHook = ''
    echo "[+] Disassembly & Reverse Engineering Environment"
    echo "Tools: python3, python2, scapy, and more..."
    echo ""

    # Radare2 setup
    alias r2='radare2 -A'     # Auto-analyze on load
    alias r2d='radare2 -d'    # Debug mode

  '';

  env = {
    # Prefer Intel syntax
    DISASSEMBLER_SYNTAX = "intel";
  };
}

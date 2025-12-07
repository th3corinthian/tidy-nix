{ pkgs, commonEnv, lib }:

{
  # Profile-specific packages
  packages = with pkgs; [

    seclists

    # Debuggers
    gdb
    lldb
    valgrind

    # DNS
    dnschef
    dnsrecon
    dnsenum
    dig

    # Analysis tools
    strace
    ltrace

    # Disassemblers
    radare2

    # Memory profiling
    massif-visualizer
    heaptrack

    # Network debugging
    wireshark
    tcpdump
    nmap

    # Fuzzing
    honggfuzz
    gobuster
    ffuf
    wpscan

    # Enum
    whatweb

    # Scanners
    nuclei
    nuclei-templates
    cent
    nikto
    sslscan

    # Static analysis
    cppcheck
    clang-tools  # includes clang-tidy, clang-format

    # Binary inspection
    binutils
    patchelf
    binwalk

    # Reverse engineering helpers
    ghidra
    iaito        # GUI for radare2

    # Password Crackers
    john
    hashcat
    thc-hydra

    # C2
    metasploit

    exploitdb

    # Man-in-the-Middle
    bettercap
    ettercap

    # Active Directory
    bloodhound
    bloodhound-py

    # OSINT
    maltego
    theharvester

    # Wi-Fi Attacks
    cowpatty
    airgeddon
    aircrack-ng

    # Forensics
    autopsy

    # Reverse-Proxy
    burpsuite

    inetutils
  ];

  # Profile-specific shell setup
  shellHook = ''
    echo "[+] Bug Hunting Environment"
    echo "Tools: gdb, valgrind, radare2, ghidra, metasploit, strace, john, and much more..."
    echo ""

    # Set up GDB with pretty printers
    export GDB_INIT="$HOME/.gdbinit"

    # Radare2 config
    export R2_HOME="$HOME/.config/radare2"

    # Helper aliases
    alias r2='radare2'
    alias vg='valgrind --leak-check=full --show-leak-kinds=all'
    alias gdb-run='gdb -ex run --args'
  '';

  # Environment variables specific to this profile
  env = {
    ASAN_OPTIONS = "detect_leaks=1";
    UBSAN_OPTIONS = "print_stacktrace=1";
  };
}

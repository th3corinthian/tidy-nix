{ pkgs, commonEnv, lib }:

{
  wordlistDir = "/tmp/tidy-wordlists";
  toolsDir = "/tmp/tidy-tools";

  setupScript = pkgs.writeShellScriptBin "setup-bughunting" ''
    set -euo pipfail
    echo "[+] Setting up bug hunting environment..."


    # Create directories
    mkdir -p ${wordlistDir} ${toolsDir}

    if [ ! -d "${wordlistDir}/SecLists" ]; then
      echo "Downloading wordlists..."
      ${pkgs.curl}/bin/curl -L "https://github.com/danielmiessler/SecLists/archive/master.tar.gz" \
              | ${pkgs.gzip}/bin/gzip -dc \
              | ${pkgs.tar}/bin/tar -x -C ${wordlistsDir}
            mv ${wordlistsDir}/SecLists-master ${wordlistsDir}/SecLists
          fi

     # Download rockyou.txt if not present
     if [ ! -f "${wordlistsDir}/rockyou.txt" ]; then
        echo "[+] Downloading rockyou.txt..."
            ${pkgs.curl}/bin/curl -L "https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt" \
              -o ${wordlistsDir}/rockyou.txt
          fi

     # Clone payload collections
     if [ ! -d "${toolsDir}/PayloadsAllTheThings" ]; then
        echo "[+] Cloning PayloadsAllTheThings..."
        ${pkgs.git}/bin/git clone --depth 1 \
                            https://github.com/swisskyrepo/PayloadsAllTheThings.git \
                            ${toolsDir}/PayloadsAllTheThings
        fi

     if [ ! -d "${toolsDir}/fuzzdb" ]; then
        echo "[+] Cloning fuzzdb..."
             ${pkgs.git}/bin/git clone --depth 1 \
                                 https://github.com/fuzzdb-project/fuzzdb.git \
                                 ${toolsDir}/fuzzdb
        fi

     # Setup environment variables
     echo "export WORDLISTS_DIR=${wordlistsDir}" >> $out
     echo "export TOOLS_DIR=${toolsDir}" >> $out
     echo "export FUZZDB=${toolsDir}/fuzzdb" >> $out
     echo "export PAYLOADS_ALL_THE_THINGS=${toolsDir}/PayloadsAllTheThings" >> $out

     echo "[+] Setup complete! Resources available in:"
     echo "   Wordlists: ${wordlistsDir}"
     echo "   Tools: ${toolsDir}"
  '';

  
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

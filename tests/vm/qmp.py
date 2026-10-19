#!/usr/bin/env python3
"""Sends one QMP command to a running test VM.

    qmp.py <socket> <command>

Exits non-zero when the socket doesn't answer (VM not running).
"""

import json
import socket
import sys


def main():
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    path, command = sys.argv[1:]
    s = socket.socket(socket.AF_UNIX)
    s.settimeout(5)
    s.connect(path)
    f = s.makefile("rw")
    f.readline()  # greeting
    for execute in ("qmp_capabilities", command):
        f.write(json.dumps({"execute": execute}) + "\n")
        f.flush()
        f.readline()


if __name__ == "__main__":
    main()
